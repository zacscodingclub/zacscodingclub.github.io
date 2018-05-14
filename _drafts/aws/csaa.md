# Amazon Certified Solutions Architect Notes

## 10000' View
* System Manager for Runbook like commands

### Don't Freak Out
* Solutions Architect Associate
  * "assets/csaa_topics.png"

* Developer Associate
  * "assets/da_topics.png"
  * lots of overlap with solutions architect

* Sysops Admin Associate
  * "assets/saa_topics.png"
  

## IAM
* Centralized control of your AWS account
* Shared Access to your AWS account
* Granular Permissions
* Identity Federation (connect to external sources)
* MFA
* Provide temp access for users/devices and services where necessary

### Critical Terms
* Users - End  Users 
* Groups - Collections of users under one set of permissions
* Roles - connect AWS resources (Users -> services, services -> services)
* Policies - defines one or more permissions

### First Lab
1. Created a User
2. Created a Group and placed the User in the Group
3. Created 3 more Groups with various file/access privileges depending on the type of services they require, e.g. system administrators, dev, hr, it, etc.

* Roles
Grant permissions to entities you trust.  IAM user, EC2 instances performing actions on AWS. 


```json
// This is an example of Admin access
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```

## AWS Object Storage and CDN
### S3 Simple Storage Services
* Object-based, i.e. allows you to upload files, not programs
* Files can be from 0 Bytes to 5 TB
* Unlimited Storage
* Files are stored into buckets.
* buckets are special because they have a universal namespace, meaning they must be unique globally.
* Receive 200 if upload was successful

#### S3 - Data Consistency Model
* Read after Write consistency for PUTS of new Objects
* Eventual Consistency for overwrite PUTS and DELETES (can take some time to propagate)

#### S3 - Simple Key-Value Store
* Key (Simple the name of the object)
* Value (sequence of bytes)
* Version ID
* Metadata
* Subresources:
  * Access Control Lists
  * Torrent

#### S3 - The Basics
* Built for 99.99% availablity
* Amazon guarantee 99.9% availablity
* Amazon guarantees 11 9s durability 
* Lifecycle Management
* Versioning
* Encryption
* Secure using Access Control Lists and Bucket Policies

#### S3 - Storage Tiers
1. S3 Standard: 99.99% availability, 11 9s durability, stored redundantly accros multipe devices in multiple facilities. Can handle loss of 2 facilities concurrently.

2. S3 IA (Infrequently Accessed): Accessed less frequently, but requires rapid access when needed.  Lower fee than S3, but charged a retrieval fee.

3. S3 One Zone - IA: even lower cost than S3 IA but only available in 1 zone.

4. Glacial: Very cheap but only for archival purposes.  Expedited, Standard or Bulk. Standard retrieval takes 3-5 hours.

#### S3 - Charges
* Charged for:
  1. Storage space
  2. Requests
  3. Storage Management pricing
  4. Data transfer pricing (cross-region replication)
  5. Transfer Accelleration 
    * enables fast, easy, and secure transfers of files over long distances between your end users and an S3 bucket.  Takes advantage of CloudFront's globally distributed edge locations.
  
#### S3 - Exam Tips
* Read S3 FAQs before taking the exam.


### CloudFront CDN
A content delivery network (CDN) is a system of distributed servers that deliver webpages and other web content to a user based on the geographic locations of the user, the origin of the webpage and a content delivery server.
* Edge Location - where content is actually cached.  Separate to an AWS Region/AZ
* Origin - origin of all files that CDN distributes.  Can be S3 Bucket, an EC2 Instance, ELB or Route53.
* Distribution - name given to CDN which consists of a collection of Edge Locations
* Web Distributions - typically websites
* RTMP - streaming media
* Objects are cached for the life of the TTL
* You can clear cached objects (Invalidate), but you will be charged

#### Video Steps
CloudFront ->
  Web -> Form

#### S3 Encryption
* In Transit: SSL/TLS
* At Rest:
  * Server
    1. S3 Managed Keys - SSE-S3
    2. AWS Key Management Service, Managed Keys - SSE-KMS
    3. Service Side Encryption with Customer Provided Keys - SSE-C
* Client Side Encryption


 

## EC2 - The backbone of AWS

## Route53

## Databases on AWS

## VPC

## Application Services

## Real World Fault Tolerant WP Site

## Preparing for the Exam

## Well Architechted Framework

## Additional Exam Tips
