# name: discourse-apt-crowd
# about: Integration with apt-crowd api
# version: 0.0.7
# authors: David Hahn, Chad Boschert

require 'json'
require_relative 'lib/api_wrapper'

register_asset "stylesheets/apt-crowd.scss"
enabled_site_setting :apt_crowd_api_uri
enabled_site_setting :apt_crowd_api_username
enabled_site_setting :apt_crowd_api_password

PLUGIN_NAME ||= "apt_crowd".freeze

after_initialize do
  Mime::Type.register "image/svg+xml", :svg
  aptCrowdApi = AptCrowd::ApiWrapper.new(
    SiteSetting.apt_crowd_api_uri,
    SiteSetting.apt_crowd_api_username, 
    SiteSetting.apt_crowd_api_password
  )

  DiscourseEvent.on(:topic_created) do |topic, _, user|
    if topic.archetype == "regular" and topic.category_id > 4
      post = topic.first_post
  
      requestBody = {
	convo_srcid: topic.id.to_s,
        post_srcid: post.id.to_s,
        subject: topic.title.to_s,
        body: post.raw.to_s,
        category_srcid: topic.category_id.to_s,
	category: topic.category.name.to_s,
        author_srcid: topic.user_id.to_s,
	author_name: topic.user.name.to_s,
	author_email: topic.user.email.to_s,
	post_timestamp_utc: topic.created_at.utc
      } 

      topic.meta_data[:apt_crowd_request] = aptCrowdApi.ask(requestBody)
      topic.save
    end
  end

  add_to_serializer(:topic_view, :apt_crowd_request) do 
    if object.topic.custom_fields.key?("apt_crowd_request")
      return JSON.parse(object.topic.custom_fields["apt_crowd_request"])
    end
  end

  add_to_serializer(:topic_view, :apt_crowd_request_seen) do 
    if (object.guardian.user && object.topic.user.id != object.guardian.user.id) ||
       !object.topic.custom_fields.key?("apt_crowd_request") ||
       object.topic.custom_fields.key?("apt_crowd_request_seen")
      return true
    end
  end

  module ::AptCrowd
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace AptCrowd
      

      Dir[Rails.root.join("plugins/discourse-plugin-aptcrowd/public/images/*")].each do |src|
        dest = Rails.root.join("public/images/#{File.basename(src)}")
        File.symlink(src, dest) if !File.exists?(dest)
      end

    end
  end

  require_dependency "application_controller"

  class AptCrowd::RequestsController < ::ApplicationController
    requires_plugin PLUGIN_NAME
    
    def silence
      topic = Topic.find(params[:topic_id])

      topic.meta_data[:apt_crowd_request_seen] = true
      topic.save

      render json: true
    end

    def invite
      topic = Topic.find(params[:topic_id])
      user = User.find(params[:user_id])

      changes = { raw: topic.first_post.raw + "\n@" + user.username }
      opts = { bypass_rate_limiter: true }
      revisor = PostRevisor.new(topic.first_post, topic)
      revisor.revise!(current_user, changes, opts)

      render json: { invited: true, topic_id: topic.id, user: user } 
    end

    def lookup_user
      user = User.find(params[:user_id])
      
      render json: user
    end
  end

  AptCrowd::Engine.routes.draw do
    post "/silence/:topic_id" => 'requests#silence'
    post "/invite/:topic_id" => 'requests#invite'
    post "/lookup-user/:user_id" => 'requests#lookup_user'
  end

  Discourse::Application.routes.append do
    mount ::AptCrowd::Engine, at: "/apt_crowd"
  end
end
