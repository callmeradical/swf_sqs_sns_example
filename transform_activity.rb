##
# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#
#  http://aws.amazon.com/apache2.0
#
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
##

require 'yaml'
require_relative 'basic_activity.rb'

# **SubscribeTopicActivity** sends an SMS / email message to the user, asking for
# confirmation.  When this action has been taken, the activity is complete.
class TransformActivity < BasicActivity

  def initialize
    super('transform_activity')
  end


  def do_activity(task)
    sqs_client = AWS::SQS::Client.new(
      :config => AWS.config.with(:region => $SMS_REGION)) 
    q_url = sqs_client.get_queue_url(:queue_name => 'sqs_testing')[:queue_url]
    q = AWS::SQS::Queue.new(q_url)
    while (q.approximate_number_of_messages > 0)

      puts 'Going through all messages in queue...'
      puts 'Current number of messages:' + "#{q.approximate_number_of_messages}"
      
      message = sqs_client.receive_message(:queue_url => q_url)
      unless message[:messages].empty?
        message_body = message[:messages].first[:body]
      end
      puts 'Received the following message in the message queue...'
      puts "#{message_body}"
      puts 'and the reversal of this message...'
      puts "#{message_body.reverse}"
      puts 'now deleting message...'
      sqs_client.delete_message(
        :queue_url => q_url, 
        :receipt_handle => message[:messages].first[:receipt_handle]
      )
    end
    @results = { :queue_size => q.approximate_number_of_messages }.to_yaml
    return true
  end
end
