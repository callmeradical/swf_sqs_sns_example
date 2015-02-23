# swf_sqs_sns_example
This is a sample project tying together SNS &amp; SQS within Amazon's Simple WorkFlow service.

You will have to add some API keys to the aws-config.txt file in order to get started with this demo.

The demo was done using the aws-sdk-v1 gem not v2. There is a pretty quick and dirty implementation of taking
a message from SNS to SQS and consuming the message from SQS. Ideally you could use this to take in an object,
apply a transformation, send it to a database or some type of long term storage.


Launch the workflow w/ :
ruby swf_sns_workflow.rb
