# name: discourse-apt-crowd
# about: Integration with apt-crowd api
# version: 0.0.1
# authors: David Hahn

require 'json'
require_relative 'lib/api_wrapper'

register_asset "stylesheets/apt-crowd.scss"
enabled_site_setting :apt_crowd_api_username
enabled_site_setting :apt_crowd_api_password

PLUGIN_NAME ||= "apt_crowd".freeze

after_initialize do
  aptCrowdApi = AptCrowd::ApiWrapper.new(
    SiteSetting.apt_crowd_api_username, 
    SiteSetting.apt_crowd_api_password
  )

  DiscourseEvent.on(:topic_created) do |topic, _, user|
    post = topic.first_post

    requestBody = {
      title: topic.title,
      message_body: post.raw,
      category_id: topic.category_id.to_s,
      author_id: topic.user_id.to_s,
      post_id: post.id.to_s,
      topic_id: topic.id.to_s,
      tags: topic.tags.map(&:name)
    } 

    topic.meta_data[:apt_crowd_request] = aptCrowdApi.ask(requestBody)
    topic.save
  end

  add_to_serializer(:topic_view, :apt_crowd_request) do 
    if object.topic.custom_fields.key?("apt_crowd_request")
      return JSON.parse(object.topic.custom_fields["apt_crowd_request"])
    end
  end

  add_to_serializer(:topic_view, :apt_crowd_request_seen) do 
    if object.topic.custom_fields.key?("apt_crowd_request_seen")
      return true
    end
  end

  module ::AptCrowd
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace AptCrowd
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
  end

  AptCrowd::Engine.routes.draw do
    post "/silence/:topic_id" => 'requests#silence'
  end

  Discourse::Application.routes.append do
    mount ::AptCrowd::Engine, at: "/apt_crowd"
  end
end
