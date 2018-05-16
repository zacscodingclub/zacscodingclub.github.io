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

2. S3 IA (Infrequently Accessed): Accessed less frequently, but requires rapid access when needed.  Lower fee than S3, but charged a retrieval fee. Can transition to IA after 30 days from creation in AWS.

3. S3 One Zone - IA: even lower cost than S3 IA but only available in 1 zone.

4. Glacial: Very cheap but only for archival purposes.  Expedited, Standard or Bulk. Standard retrieval takes 3-5 hours.  Can transition to Glacial after 60 days from creation in AWS.

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

### Storage Gateway
Connects on-prem software appliance with cloud-based storage to provide seamless and secure integration between an organization's on-prem IT environment and AWS storage infrastructure.  The service enables you to securely store data to the AWS cloud for sclalable and cost-effective storage.
 
Basically it's an application that lives on your hypervisor to replicate data up to AWS.
#### Types of Storage Gateway
1. File Gateway (NFS)
  * Flat files are stored as objects in S3 and accessed through a NFS mount point.  Ownership, permissions, and timestamps are stored in S3 in the user-metadata.  Once transferred to S3, normal S3 policies can be applied to the objects.
2. Volumes Gateway (iSCSI, block based)
  1. Stored Volumes
  2. Cached Volumes - most recent data is on prem and old data replicated on the cloud
  * Data written to these volumes cna be asynchronously backed up as a point-in-time snapshots.  Snapshots are incrementaly backups that capture only changed blocks.  All snapshots are compressed.

3. Tape Gateway (YTL)
  * durable, cost-effective solution for archiving to the cloud.  The interface allows you to leverage existing tape-based backup solutions.  Each Tape Gateway is preconfigured with a media changer and tape drives, which are available to your existing client backup applications as iSCSI devices.  You add tape cartridges as you need to archive your data.  Supported by NetBackup, Backup Exec, Veeam, etc. 

### Snowball
* Import/Export Disk
Accelerates moving large amounts of data into and out of the AWS cloud using portable storage devices for transport.  AWS Import/Export Disk transfers directly onto and off of storage devices using Amazon's high-speed internal network and bypassing the internet.

1. Snowball
Petabyte-scale data transport solution thath uses secure appliances to transfer large amounts of data into and out of AWS.  This addresses common challenges with large-scale data transfers including high network costs, long transfer times, and security concerns.  Transferring data with Snowball is simple, fast, secure, and can be as little as 1/5th the cost of high-speed internet.

80TB Snowball in all regions.  It uses multiple layers of security like the tamper-resistant case, 256-bit encryption, and Trusted Platform Module TPM designed to ensure security + full chain-of-custody of your data. Once complete, all data will be removed from the Snowball appliance.

2. Snowball Edge (tiny AWS data center)
100TB device with on-board storage and compute capabilities (Lambda).  Can be used to move data into and out of AWS, a temporary storage tier for large local datasets, or to support local workloads in remote or offline locations. 

3. Snowmachine
It's a semi-truck sized devise to handle up to 100 petabyte per device.  Ordering an exobyte (10x 1PB), would take 6 months to complete.
  
### S3 Transfer Acceleration
Utilizes CloudFront Edge Network to accelerate your uploads to S3.  You can use a distinct URL to upload directly to an edge location which will then transfer that file to your actual S3 bucket using Amazon's backbone infrastructure.

### Create a Static Website Using S3
You've already done this.
Edpoint always in this format:
http://<bucket-name>.s3-website-us-east-1.amazonaws.com

### S3 Summary
* S3 101
  * Object based, i.e. files, stored in Buckets with a universal namespace (globally)
  * file sizes 0 Bytes to 5TB, with unlimited storage
  * Read after Write consistentcy for PUTS of new Objects
  * Eventual consistency for overwrite PUTS and DELETES
  * S3 Standard: 99.99% available, 11 9s durability.  Redundancy across facilities and designed to sustain the loss of 2 facilities concurrently.
  * S3 - IA (Infrequently Accessed): For data accessed infrequently, but requires quick access when used.  Data retrieval fee.
  * S3 One Zone - IA: Lower cost version of above for your local region only.
  * Glacier: very cheap but archival only.  Expedited, Standard or Bulk retrieval rates.


* CloudFront

* Storage Gateway

* Snowball

* Transfer Acceleration


## EC2 - The backbone of AWS

## Route53

## Databases on AWS

## VPC

## Application Services

## Real World Fault Tolerant WP Site

## Preparing for the Exam

## Well Architechted Framework

## Additional Exam Tips
