# name: discourse-apt-crowd
# about: Integration with apt-crowd api
# version: 0.0.1
# authors: David Hahn

require 'json'

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
      apt_crowd_request: fakeResponse
    }
  });
end

after_initialize do
  add_to_serializer(:topic_view, :apt_crowd_request) do 
    if object.topic.custom_fields.key?("apt_crowd_request")
      return object.topic.custom_fields["apt_crowd_request"]
    end
  end
end

def fakeResponse
  {
    'response_id' => '1234',
    'posts' => [
        {
            'title' => 'Follow these Steps',
            'preview_html' => '1. Drape the <em>sheet</em> over your hands. With the top two corners inside out and the elastic edge facing you, hold the <em>fitted sheet</em> with one hand in each of the top corners...',
            'post_url' => '#'
        },
        {
            'title' => 'How to Fold a Fitted Sheet',
            'preview_html' => 'Stand holding the <em>sheet</em> by the two adjacent corners of one of the shorter edges. With the <em>sheet</em> inside out, place one hand in each of these two corners. 2. Bring your right hand...',
            'post_url' => '#'
        },
        {
            'title' => 'How to Fold a Fitted Sheet: 12 Steps (with Pictures)',
            'preview_html' => '<em>How to Fold a Fitted Sheet</em>. This wikiHow will teach you how to fold a <em>fitted sheet</em>. Hold the <em>sheet</em> lengthwise in your hands. Tuck your fingertips into the corner...',
            'post_url' => '#'
        }
    ],
    'peers' => [
        {
            'author' => 'Beth Chamberlain',
            'author_id' => '123',
            'skills' => ['Laundry', 'Folding', 'DIY'],
            'avatar_url' => '#'
        },
        {
            'author' => 'Joseph Wilbourn',
            'author_id' => '243',
            'skills' => ['Home', 'Laundry'],
            'avatar_url' => '#'
        },
        {
            'author' => 'Warren Robinson',
            'author_id' => '345',
            'skills' => ['Bedding', 'Home'],
            'avatar_url' => '#'
        },
    ],
    'vendors' => [
        {
            'name' => 'Target',
            'vendor_id' => '12',
            'preview_html' => 'Ultra Soft Pillowcase Set 300 Thread Count - Thres... Organic Cotton <em>Sheet</em> Set 300 Thread Count - Thresh... Classic Percale <em>Sheet</em> Set 300 Thread Count - Thre...',
            'website' => '#',
            'logo_url' => '#'
        },
        {
            'name' => 'Amazon.com',
            'vendor_id' => '23',
            'preview_html' => 'Fitted <em>Sheet</em> - Deep Pocket Brushed... <em>Fitted Sheet</em> (Queen - White) - Deep Pocket Brushed Velvety Microfiber, Breathable, Extra Soft and Comfortable - Wrinkle, Fade, Stain... <em>Fitted Sheet</em> (Pack of 6, Twin, White) Deep Pocket Brushed Velvety Microfiber, Breathable, Soft...',
            'website' => '#',
            'logo_url' => '#'
        },
        {
            'name' => 'Macy\'s',
            'vendor_id' => '34',
            'preview_html' => 'Hotel Collection 680 Thread Count 100% Supima Cotton Extra-Deep Twin <em>Fitted Sheet</em>, Only at Macy\'s... Hotel Collection 680 Thread Count 100% Supima Cotton Queen <em>Fitted Sheet</em>, Only at Macy\'s... Hotel Collection 680 Thread Count 100% Supima Cotton King <em>Fitted Sheet</em>, Only at Macy\'s.',
            'website' => '#',
            'logo_url' => '#'
        }
    ]
  }.to_json
end

