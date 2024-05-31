# question-2
This is repo for question 2 and includes files related to question 2 

# Steps to AWS pulish message and receive messsage maually
1. Created a SNS Topic in Account A
2. Created a SQS Queue in Account B
3. Updated the SNS Topic Access Policy and provided "SNS Subscribe" permissions to Queue in Account B
4. From Queue in Account B Subscribed to SNS Topic in Account A
5. Published message in Account A and polled for messages in Account B, received the messages.

