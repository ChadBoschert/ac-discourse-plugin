# name: discourse-apt-crowd
# about: Integration with apt-crowd api
# version: 0.0.1
# authors: David Hahn

DiscourseEvent.on(:topic_created) do |topic, _, user|
  post = topic.first_post;

  requestBody = {
    title: topic.title,
    message_body: post.raw,
    category_id: topic.category_id,
    author_id: topic.user_id,
    post_id: post.id,
    topic_id: topic.id,
    tags: ['tag1', 'tag2']
  } 

  topic.update_attributes({
    meta_data: {
      apt_crowd_request: 'totes just a test'
    }
  });
end

after_initialize do
  # require 'topic_list_item_serializer'
  #
  # class ::TopicListItemSerializer
  #   alias_method :_custom_fields, :custom_fields
  #
  #   raise TopicListItemSerializer.methods.sort.inspect
  #
  #   def custom_fields
  #     if object.custom_fields["apt_crowd_request"]
  #       object.custom_fields["apt_crowd_request"] = ""
  #       object.svae
  #     end
  #     
  #     _custom_fields
  #   end
  # end

  add_to_serializer(:topic_view, :apt_crowd_request) do 
    if object.topic.custom_fields.key?("apt_crowd_request")
      return object.topic.custom_fields["apt_crowd_request"]
    end
  end
end
