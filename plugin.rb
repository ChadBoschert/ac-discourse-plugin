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

  raise requestBody.inspect
end
