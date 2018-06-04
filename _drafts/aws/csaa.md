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

* Users - End Users
* Groups - Collections of users under one set of permissions
* Roles - connect AWS resources (Users -> services, services -> services)
* Policies - defines one or more permissions

### First Lab

1.  Created a User
2.  Created a Group and placed the User in the Group
3.  Created 3 more Groups with various file/access privileges depending on the type of services they require, e.g. system administrators, dev, hr, it, etc.

* Shared Responsibility Model
  AWS is responsible for security 'of' the cloud, just like you are responsible for security 'in' the cloud.
  Manged by You: "Customer data", "platform & application management", "os, network & firewall config", "customer IAM", "client-side encryption", "network traffic protection"

* Users

* IAM Policies
  By default, users ca't access anything in your account and you have to grant them permissions through IAM policies.

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
// dynamodb
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "dynamodb:*",
    "Resource": "arn:aws:dynamodb:us-west-s:<numbers>:table/<table-name>"
  }
}
```

* User vs Resource Based Policies
  IAM policies (resource-level) are attached to a user, group or role and specify the actions that are permitted and the resource that can be accessed.
  Resource-Based policies (as opposed to IAM policies) are attached to a resource and only available for: S3, Glacier, SNS, SQS, KMS

* Groups

* Roles
  Grant permissions to entities you trust. IAM user, EC2 instances performing actions on AWS.

* Identity Federation

1.  An IAM role can be used to specify permissions for externally identified (federated) users.
2.  Max 5k IAM users per account. Identity federation enbables unlimited temp credentials.
3.  Identified by your organization or a third-party identity provider
    Ways to Federate: Cognito, Oauth, SAML, AD, etc.

### Trusted Advisor

Cost Optimization, Performance, Security, Fault Tolerance recommendations

## AWS Object Storage and CDN

### S3 Simple Storage Services

* Object-based, i.e. allows you to upload files, not programs
* Files can be from 0 Bytes to 5 TB
* Unlimited Storage
* Files are stored into buckets.
* buckets are special because they have a universal namespace, meaning they must be unique globally.
* Receive 200 if upload was successful

#### Key Terms

1.  Bucket: uniquely named container for objects stored in S3
2.  Objects: Entities (data and metadata) stored in a bucket, 0B up to 5TB (multi-upload if >100MB)
3.  Keys: unique identifier of object in a bucket. bucket, key, and version ID

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

1.  S3 Standard: 99.99% availability, 11 9s durability, stored redundantly accros multipe devices in multiple facilities. Can handle loss of 2 facilities concurrently.

2.  S3 IA (Infrequently Accessed): Accessed less frequently, but requires rapid access when needed. Lower fee than S3, but charged a retrieval fee. Can transition to IA after 30 days from creation in AWS.

3.  S3 One Zone - IA: even lower cost than S3 IA but only available in 1 zone.

4.  Glacial: Very cheap but only for archival purposes. Expedited, Standard or Bulk. Standard retrieval takes 3-5 hours. Can transition to Glacial after 60 days from creation in AWS.

#### S3 - Charges

* Charged for:

  1.  Storage space
  2.  Requests
  3.  Storage Management pricing
  4.  Data transfer pricing (cross-region replication)
  5.  Transfer Accelleration

  * enables fast, easy, and secure transfers of files over long distances between your end users and an S3 bucket. Takes advantage of CloudFront's globally distributed edge locations.

#### S3 - Exam Tips

* Read S3 FAQs before taking the exam.

### CloudFront CDN

A content delivery network (CDN) is a system of distributed servers that deliver webpages and other web content to a user based on the geographic locations of the user, the origin of the webpage and a content delivery server.

* Edge Location - where content is actually cached. Separate to an AWS Region/AZ
* Origin - origin of all files that CDN distributes. Can be S3 Bucket, an EC2 Instance, ELB or Route53.
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
    1.  S3 Managed Keys - SSE-S3
    2.  AWS Key Management Service, Managed Keys - SSE-KMS
    3.  Service Side Encryption with Customer Provided Keys - SSE-C
* Client Side Encryption

### Storage Gateway

Connects on-prem software appliance with cloud-based storage to provide seamless and secure integration between an organization's on-prem IT environment and AWS storage infrastructure. The service enables you to securely store data to the AWS cloud for sclalable and cost-effective storage.

Basically it's an application that lives on your hypervisor to replicate data up to AWS.

#### Types of Storage Gateway

1.  File Gateway (NFS)

* Flat files are stored as objects in S3 and accessed through a NFS mount point. Ownership, permissions, and timestamps are stored in S3 in the user-metadata. Once transferred to S3, normal S3 policies can be applied to the objects.

2.  Volumes Gateway (iSCSI, block based)
1.  Stored Volumes
1.  Cached Volumes - most recent data is on prem and old data replicated on the cloud

* Data written to these volumes cna be asynchronously backed up as a point-in-time snapshots. Snapshots are incrementaly backups that capture only changed blocks. All snapshots are compressed.

3.  Tape Gateway (YTL)

* durable, cost-effective solution for archiving to the cloud. The interface allows you to leverage existing tape-based backup solutions. Each Tape Gateway is preconfigured with a media changer and tape drives, which are available to your existing client backup applications as iSCSI devices. You add tape cartridges as you need to archive your data. Supported by NetBackup, Backup Exec, Veeam, etc.

### Snowball

* Import/Export Disk
  Accelerates moving large amounts of data into and out of the AWS cloud using portable storage devices for transport. AWS Import/Export Disk transfers directly onto and off of storage devices using Amazon's high-speed internal network and bypassing the internet.

1.  Snowball
    Petabyte-scale data transport solution thath uses secure appliances to transfer large amounts of data into and out of AWS. This addresses common challenges with large-scale data transfers including high network costs, long transfer times, and security concerns. Transferring data with Snowball is simple, fast, secure, and can be as little as 1/5th the cost of high-speed internet.

80TB Snowball in all regions. It uses multiple layers of security like the tamper-resistant case, 256-bit encryption, and Trusted Platform Module TPM designed to ensure security + full chain-of-custody of your data. Once complete, all data will be removed from the Snowball appliance.

2.  Snowball Edge (tiny AWS data center)
    100TB device with on-board storage and compute capabilities (Lambda). Can be used to move data into and out of AWS, a temporary storage tier for large local datasets, or to support local workloads in remote or offline locations.

3.  Snowmachine
    It's a semi-truck sized devise to handle up to 100 petabyte per device. Ordering an exobyte (10x 1PB), would take 6 months to complete.

### S3 Transfer Acceleration

Utilizes CloudFront Edge Network to accelerate your uploads to S3. You can use a distinct URL to upload directly to an edge location which will then transfer that file to your actual S3 bucket using Amazon's backbone infrastructure.

### Create a Static Website Using S3

You've already done this.
Edpoint always in this format:
http://<bucket-name>.s3-website-us-east-1.amazonaws.com

## EC2 - The backbone of AWS

### EC2 101

Elastic Compute Cloud - web service that provides resizable compute capacity in the cloud. Reduces the time required to obtain and boot new server instance to minutes, allowing quickly scaling to capacity (up and down), as requirements change.

Allows users to pay for capacity that is actually used.

### EC2 Options

* On Demand - pay fixed rate by hour (or second) without commitment

  * Good fo rusers that want low cost and flexibility of EC2 without an up-front payment or long-term commitment
  * Applications with short term, spiy, or unpredictable workloads that cannot be interrupted
  * Applications being developed or tested on EC2 for the first time

* Reserved - provides you with a capacity reservation and offer a significant discount on the hourly charge (1 or 3 year terms)

  * Applications with steady state or predictable usage, that require reserved capacity.
  * Users can make up-front payments to reduce their total computing costs
  * Standard RIs (up to 75% off on-demand)
  * Convertible RIs (up to 54% off on-demand), ability to change attributes of RI as long as exchange results in creation <= value
  * Scheduled RIs available during reserved time windows.

* Spot - bid whatever price you want for isntance capacity, providing even greater savings if your applications have flexible start and end times

* Dedicated Hosts - physical server dedicated for your use. Dedicated hosts can help reduce costs by allowing you to use existing server-bound software licenses (SQL Server, VMware, etc)
  * Useful for regulatory requirements that may not support multitenant virtualization

### EC2 Instance Types

[instance types](link to screenshot)
Fight Dr Mcpx
F: FPGA
I: iops
G: graphics
H: High disk throughput
T: cheap, general purpose
D: Density
R: RAM
M: main choice for general purpose apps
C: compute
P: graphics
X: Extreme memory

* General Purpose (T2, M3, M4)
* Compute Optimized (C3, C4)
* Memory Optimized (R3)
* GPU (G2)
* Storage Optimized (I2, D2)

T2 Burstable Performance Instances

* baseline performance and ability to burst are governed by CPU credits
* Credits are built up and stored for up to 24 hrs while instance is operating below baseline
* Credits are used to burst above baseline capacity when needed
* If you can't maintain a CPU Credit balance, consider upgrading to a larger instance

### EC2 Container Service (ECS)

Use Docker containers to launch EC2 containers.  
Docker wraps everything up into a container -> Shipped to EC2 Container Registry (ECR) -> ECS -> EC2 Instance(s)

### EBS

EBS allows you to create storage volumes and attach them to EC2 instances. Once attached, you can create a file system on top of these volumes, run a database, or use them in any other way you would use a block device. EBS volumes are placed ina specific AZ where they are automatically replicated to protect you from a single component failure.

* General Purpose SSD (GP2): balances price and performance
  * Ration of 3 IOPS per GB with up to 10k IOPS and ability to burst up to 3k IOPS for extended perios of times.
* Provisioned IOPS SSD (IO1)
  * Designed for I/O intensive applications such as large relational or NoSQL databases
  * Use if you need more than 10k IOPS
* Throughput Optimized HDD (ST1)
  * Big data, data warehouses, log processing, cannot be a boot volume
* Cold HDD (SC1)
* Magnetic (Standard)

  * Lowest cost per GB of all EBS volume types that is bootable. Magnetic volumes are ideal for workloads where data is accessed infrequently, and applications where the lowest storage cost is important.

* EBS Snapshots
  * Point in time, incremental backup of EBS volume to S3
  * Can be copied to other regions or accounts
* EBS Encryption
  * KMS or CMK keys
  * Data stored at rest can be encrypted

### EBS Volumes (Lab)

Steps

1.  Launch EC2 instance
2.  Step 4 in the process Add Storage: add EBS volume(s)
3.  Volumes (left nav bar) must be in same AZ as instance
4.  select a volume -> Modify (dropdown) (cannot modify magnetic storage types)
5.  select a volume -> Modify -> Create a Snapshot
6.  Snapshots (left nav bar) -> Create Volume (or Image) (can change options and zones at this point)
7.  Snapshots (left nav bar) -> Create Image (good for creating new instances with an expected configuration)

* Volumes exist on EBS:
  * Virtual hard disk
* Snapshots (point of time copies of Volumes) exist on S3
* Snapshots are incremental, in that only the changes are updated to S3 when created
* You can create AMIs from EBS-backed Instances and Snapshots
* EBS volume sizes can be changed on the fly, including size and storage type.
* Volumes ALWAYS in same AZ as instance
* To move an EC2 volume from one AZ/Region to another, take a snapshot or image of it, then copy it to the new AZ/Region

### AMI

A template for the root volume of an instance (i.g. os, application server, and applications). Launch permissions that control which accounts can use the AMI. Configuration management to know which block storage devices to connect to on launch

#### Create an AMI

1.  Go to EC2
2.  To take a snapshot, stop the instance so it is in a consistent state
3.  Volumes -> Create Snapshot
4.  Snapshots -> Copy (to different region) Then you can encrypt it
5.  Snapshots -> Create Image from encrypted AMI
6.  Launch -> default settings. On Add Storage, you will notice the root volume is the snapshot

* Snapshots of encrypted volumes are encrypted automatically
* Volumes restored from encrypted snapshots are encrypted automatically
* You can share snapshots, but only if they are unencrypted

#### EBS Root Volumes vs Instance Store

You can select your AMI based on:

* Region
* OS
* Architecture (32 or 64-bit)
* Launch Permissions
* Storage for the Root Device Volume

  * Instance Store (EPHEMERAL STORAGE)
  * EBS Backed Volumes

* All AMIs are categorized as either backed by EBS or instance store.
* For EBS Volumes: the root device for an instance launched from the AMI is an EBS volume created from an EBS snapshot
* For Instace Store Volumes: the root device for an instance launched from the AMIS is an instace store volume created from a templated stored in S3

* Instance Store Volumes are sometimes called Ephemeral Storage
* Instance Store Volumes cannot be stopped. If the underlying host failes, you will lose your data
* EBS backed instances can be stopped. You will not lose the data on this instance if it is stopped.
* Can reboot both without losing data
* By default, both ROOT volumes will be deleted on termination, however with EBS volumes, you can tell AWS to store the volume

### Cluster Networking

* Enhanced networking with higher I/O
  * Supported for limited instance types [R4, X1, M4, C4, C3, I2, G3, D2]
* EBS optimized instances deliver quality IOPS performance 99.9%
* Placement Groups
  * Low latency, high network throughput
  * Can't span multiple AZ.
  * Can span peered VPC but not get full bandwidth
  * Instances added at launch only
  * Can't merge Placement Groups

### Security Groups (Lab)

Steps

1.  Launch EC2 instance
2.  ssh into your new instance
3.  `yum update`
4.  `yum install http` Install Apache
5.  `service http start`
6.  `chkconfig httpd on`
7.  Create simple html file so we can have something displayed
8.  Go back to main EC2 console -> Security Groups (left nav bar)
9.  Any Security Group changes will happen instantly
10. 3 roles in inbound, 1 in outbound. Groups are stateful and so anything that comes in is also allowed back out.
11. Add rules [(rdp, tcp 3389), (mysql/aurora, tcp, 3306)]

* All inbound traffic is blocked by default
* All outbound traffic is allowed
* Changes to SG take effect immediately
* You can have any number of EC2 instances within a SG
* Multiple SG attached to an individual EC2 instance
* SG are STATEFUL
* You cannot block specific IP addresses using SG, instead use Network Access Control Lists

### Elastic Load Balancer & Health Checks (Lab)

1.  EC2 -> Launch an Instance -> SSH in and check httpd and add a `healthcheck.html` in the `/var/www/html` dir
2.  ELB -> Classic Load Balancer (routing at Layer 4 i.e. TCP) -> 80:80 -> Configure Health Check (ping the html page) -> Add Tags
3.  ELB -> Application Load Balancer (routing at Layer 7 i.e. Application) -> Configure Routing & Advanced Health Checks

* Instances monitored by ELB are reported as: InService or OutofService
* Health Checks use your settings to check the instance health
* Have their own DNS name, but never given a public IP since they can change
* Read the ELB FAQ for Classic Load Balancers ## TODO

### CloudWatch EC2 (Lab)

Basic monitoring is every 5 minutes. Detailed Monitoring makes that shorter, but takes you out of the free tier.

EC2 Metrics available by default:

* CPU: CPUCreditBalance, CPUCreditUsage, CPUUtilization
* Disk: DiskReadBytes, DiskReadOps, DiskWriteBytes,DiskWriteOps
* Network: NetworkIn, NetworkOut, NetworkPacketsIn, NetworkPacketsOut
* Health Check: StatusCheckFailed, StatusCheckFailed_Instance, StatusCheckFailed_system

What can I do with Cloudwatch?

* Dashboards - Custom dashboards with metrics relevant to you
* Alarms - Notification alarms when thresholds are hit
* Events - Response to state changes in your AWS resources (e.g. trigger Lambda on instance creation)
* Logs - aggregate, monitor, and store logs

## Route53

## Databases on AWS

### RDS

* Managed relational DB service
* Amazon Aurora, MySQL, MariaDB, Oracle, SQL Server, and PostgreSQL
* Handles routine db tasks such as provisioning, patching, backup, recovery, failure detection, and repair

#### Backup

* User initiated DB Snapshots of instance
* Automated DB backups to S3
* Encryption of DB and Snapshots at rest available

#### Multi-AZ

* Multi-AZ recommended for production applications
* Applications should also be located in multiple AZs
* Available for all DB types
* Master DB in one AZ with any changes to it getting replicated asynchronously to standby DB, which is in other AZ.
  * Change CNAME

#### Failover Process

In the event of a failover condition (incident, maintenance, etc):

* Standby instance promoted to master
* CNAME DNS record is changed to point to the standby instance
* New standy instance created to replace failed instance

#### Read Replicas

* Supported for Aurora, PostgreSQL, MySQL and MariaDB
* Multiple read replicas (up to 15 for Aurora)
* Cannot be put behind AWS ELB. (Use Route 53 routing or haproxy)

## VPC

### Subnet Addressing

TCP/IP address is a 32 bit, binary number that is represented as four bytes converted to decimal:
111111111.111111111.111111111.111111111 => 0-255.0-255.0-255.0-255

* Private Network Ranges
  Private address ranges are used within your private network as opposed to public IP addresses which are visible to the wider internet.

  * Class A Private Address = 10.0.0.0/8. begins with 10
  * Class B Private Address = 172.16.0.0/12. begins with 172.16-31
  * Class C Private Address = 192.168.0.0/16. begins with 192.168

* Subnet Mask

  * Defines the IP range of our network
  * 1s represent the network portion and 0s reprsent the hosts
  * Amazon reserves the first 4 IP addresses and the last 1 IP address of every subnet for IP networking purposes
  * e.g. Network IP address: 192.168.1.0, Subnet Mask: 255.255.255.0
    11000000.10101000.00000001|.|00000000 (IP Adress Binary)
    11111111.11111111.11111111|.|00000000 (Subnet Mask)
  * Reserved for Amazon:
    11000000.10101000.00000001|.|00000100 (First Host Address)
    11000000.10101000.00000001|.|11111110 (Last Host Address)

* Classless Inter-Domain Routing (CIDR) Notation

  * Shorthand notation defines the numer of Subnet Mask bits
  * Larger the number, fewer addresses available for hosts
    255.255.255.0 => /24
    255.255.0.0 => /20
    255.255.240.0 => /16

* Default VPC is assigned a CIDR range of 172.31.0.0/16. You are free to use other private address ranges e.g. 10.0.0.0/16
* Amazon VPC supports VPCs between /28 and /16 in size
* Min size of subnet is /28 (or 14 IP addresses). Subnets cannot be larger than the VPC in which they are created.
* To change size of VPC, you must terminate your existing VPC and create a new one.

### Connecting to a VPC

1.  Internet gateway: scalable, redundant, and highly available VPC component
2.  Virtual private gateway is the VPN concentrator on the Amazon of the VPN connection

### Route Tables

* For an instance to connect to the internet it needs:

  1.  Internet gateway
  2.  Custom route table to the internet gateway explicitly associated to the subnet containing the instance
  3.  Public IP address

* Main route table automatically created when you createa a VPC with the VPC wizard

  1.  Allows local traffic within VPC
  2.  Implicitly associated to all subnets unless another route table has been explicitly associated to the subnet

* Custom route table also automatically crated when you create a VPC with the VPC wizard
  1.  Allows local traffic within VPC
  2.  Creates a route to the internet gateway
  3.  Explicitly associated to the subnet

### Public and Private Subnets

### Network Address Translation (NAT)

* NAT Gateway
  * Allow traffic to flow from private subnet through public subnet to internet gateway
* NAT Instance (EC2)
  * EC2 instance which acts as a proxy (?)

### VPC Security

* Security Groups

* Firewall at the instance level
* Supports only allow rules
* Is stateful: return traffic is automatically allowed
* evaluate all rules before deciding whether to allow traffic

* Network access control lists (ACLs)

  * Firewall at the subnet level
  * Supports allow and deny rules
  * Is stateless: return traffic must be explicitly allowed by rules
  * process rules in number order when deciding whether to allow traffic. most restrictive deny applies

* Flow logs
  * Capture information as CloudWatch logs

## CloudFormation

* Core deployment tool using JSON (or YAML) to define the infrastructure. "Infrastructure as code"
* Version control capability
* Template describes all the AWS resources and CloudFormation takes care of provisioning and configuring.

### Template Sections

1.  Format Version
2.  Description - must always follow Format Version
3.  Metadata - objects and keys that provide more info
4.  Parameters - values to be passed at stack creation. Default parameter can be defined.

```json
"Parameters": {
  "InstanceTypeParameter": {
    "Type": "String",
    "Default": "t2.micro",
    "AllowedValues": ["t2.micro", "m1.small", "m1.large"],
    "Description": "Enter t2.micro, m1.small, or m1.large. Default is t2.micro."
  }
}
```

5.  Condtions - define when a resource is created or a property defined
6.  Outputs - declare values taht can be: Imported to other stacks, Returned to describe stack calls, or Displayed on the console

### Cloudformer

* Creates an CloudFormation templates from existing AWS resources in your account.
* You select the resources from account
* CF template is created and stored in S3 bucket
* Does not support YAML

### CloudFormation Designer

* UI for drag-and-drop interface for adding resources to templates
* Does not support YAML

## Elastic Beanstalk

* Deploys and manages applications without worrying about the infrastructure
* Capacity provisioning, load balancing, scaling, and health monitoring
* New versions can be uploading through the console, a GIT repository or IDE and, environment re-deployed
* Applications can be:
  * Docker containers
  * NodeJS, Java, .NET, PHP, Ruby, Python & Go
  * Servers: Apache, Nginx, Passenger, and IIS

## OpsWOrks

* Configuration management platform
* Provides more control over infrastructure design and management than EB
* Infrastructure as code using Chef recipes for fine-grained control
* Consists of a CM model based upon Stacks, Layers, and Recipes

### Stack

* Top-level OpsWorks entity
* Represents a set of instances an applications that you want to manage collectively
* e.g. web server stack that may contain a load balancer, server instances, and database

#### Layers, Instances, and Apps

* Define how to set up and configure instances and resources
* Stacks must contains one or more layers
* Layers must contain at least one instance
* Instances can be a member of multiple layers
* Apps represent your applications

### Scaling

* 24/7 instances added to a layer can manually start, stop, or reboot the corresponding EC2 instances
* Automatic Scaling
  * Time based instances based upon a schedule
  * Load based instances based upon several load metrics (network traffic, CPU utilization)
* Combination of all 3 types is an effective strategy

### Deploymentn and Customization

* App and associated infrastructure is deployed automatically
* Chef recipes define infrastructure as code
  * Customisation
  * Redployment
  * Version control
  * Code reuse

### OpsWorks Lab

1.  OpsWorks -> Add your first stack
2.  Use Sample stack -> automatically provisions infrastructure
3.  Instantiates instances in stopped state. Instances -> select 'Start'

## CloudWatch

### Statistics

* Average, Max, Min, etc
* CLI - get-metric-statistics, API - GetMetricStatistics
  * Maximum number of data points that can be queried is 50850
  * Max data points returned from a single request is 1440
* View with console and create dashboards

### Alarms

* Billing and resource alarms
* Integrates with SNS
* Three states: OK, ALARM, & INSUFFICIENT_DATA
* If a metric is above the alrm, threshold for the number of time periods defined by the evaluation perioed, an alarm is invoked.

### Events

* Resource changes state: EC2 state, autoscaling instance launche
* CloudTrail integration: API call, log into console
* Can invoke Lambda functions SNS topics, SQS queues, Kinesis streams or built-in targets

### Scaling

### Logs

* Monitor, store, and access log files from EC2 instances, CloudTrail, or other sources
* Real time monitoring of log information
* Log streams - sequence of log events from a source
* Log Groups - streams the same retention, monitoring, and access control settings
* Metric filters - define how information is extracted to create data points
* Retention settings - how long log events are kept in CloudWatch Logs

## Deployment

### Infrastructure as Code

* Allows infrastructure to be managed in the same way as software
* Version Control
* Examples:
  * CloudFormation Templates
  * CloudFormation Designer
  * AMI

### Continuous Deployment - Application

* Automated delivery of production ready code
* Allows rapid deployment and roll back if necessary
* Examples
  * CodeCommit
  * CodePipeline
  * Elastic BeanStalk
  * OpsWorks
  * ECS

### Continuous Deployment - Application and Infrastructure Deployment

* Examples
  * CodePipeline
  * CodeCommit
  * Elastic BeanStalk
  * OpsWorks
  * ECS
* Hybrid Deplyoments: separating Application and Database or Application and Infrastructure deployments

### Updating Options

* Prebaking AMIs (slower and more expensive)
* In-place Upgrade: Application updates on livei Amazon EC2 instances
* Disposable Upgrade
  * Rolling out new EC2 instances and terminating older instances
  * Allows staged deployment

### Blue-Green Deployments

* Staged rollout from existing (blue) environment while testing a new (green) one
* Uses DNS to increase traffic to green environmentn in stages
* Requres 2x resources

## Application Services

## Real World Fault Tolerant WP Site

## Preparing for the Exam

## Well Architechted Framework

## Additional Exam Tips
