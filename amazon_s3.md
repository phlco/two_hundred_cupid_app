# Hosting Images on Amazon S3

Heroku's file system is empheral, so any files we upload via Paperclip won't persist
on on site. If we want our images to persist, we'll need to host them somewhere else.

Amazon S3 (Simple Storage Service) is an online file storage web service offered by 
Amazon Web Services.

S3 organzies their storage into "buckets." 

###Step 1 - Create the S3 Bucket where you will store your images

- Sign up or Log in to the [Amazon S3 Management Console](https://console.aws.amazon.com/s3/home)

- Click on "Create Bucket" and give it a name, in the region of your choice. (Usually, a closer region to your userbase is the best choice.) Click on "Create".

##Identity and Access Management (IAM)

- Click on your name in the upper right bar, then click on [Security Credentials](https://console.aws.amazon.com/iam/home). As Amazon says, "The account credentials provide unlimited access to your AWS resources." So, make sure you safeguard these keys.

- **Use AWS Identity Management.** In the security popup, it recommends you create users. Click on the IAM Users button. Create a new user. 

- **Record the user's credentials.** You must not lose the Secret Access Key -- you will not be able to retrieve this later.

- **Create a Group.** Now, click on Create Group. After naming your group, select the Amazon S3 Full Access policy template. Click Next Step, then Create Group.

- **Add User to Group.** Click on Users in the left sidebar. Now, click on your new user. In the User summary page, click the button Add User to Groups. Select the group you just created then add the user to that group.

- **Consider Additional Steps.** Click on your Dashboard -- the uppermost link in the left sidebar. The Security Status section lists additional steps you can take to safeguard your account.

###Step 2 - Use figaro to hide your Amazon keys

We never want to expose our keys! It's important to hide those in our environment
and access them via the `ENV` hash.

We can either store environmental variables in our bash_profile, but we may work
on multiple projects and have multiple keys for the same services.

Figaro is a gem that helps us keep our environmental variables grouped by project.

```
# Gemfile
gem 'figaro'
```

```bash
$ bundle
```

```bash
$ figaro install
```

This creates a `config/application.yaml`

Then add your S3 keys and other data as strings in the newly generate application.yaml file

```yml
# config/application.yaml
AWS_REGION: <us-west-2 or us-west-1 etc>
AWS_KEY: <access key ID here>
AWS_SECRET: <secret access key here>
AWS_BUCKET: <your-bucket-name>
```

It should look something like this:

```yml
# config/application.yaml
AWS_REGION: 'us-west-1'
AWS_KEY: '9823lkjapdifua'
AWS_SECRET: '0923kja;df1lkja'
AWS_BUCKET: 'my-app-development'
```

Rails can then access the keys via the ENV hash!

###Step 3 - Configure Paperclip to work with S3

To configure Paperclip with Amazon S3 we need to add the `aws-sdk` to our Gemfile

```rb
# Gemfile
gem 'aws-sdk'
```

Now we need to set up our Paperclip configuration.

This is for the environment on your dev machine

```rb
# config/environments/development.rb
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => ENV['AWS_REGION'],
    :s3_credentials => {
      :access_key_id => ENV['AWS_KEY'],
      :secret_access_key => ENV['AWS_SECRET'],
      :bucket => ENV['AWS_BUCKET']
    }
  }
```

This will be for the environment in production, like when you deploy to Heroku.

```rb
# config/environments/production.rb
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_region => ENV['AWS_REGION'],
    :s3_credentials => {
      :access_key_id => ENV['AWS_KEY'],
      :secret_access_key => ENV['AWS_SECRET'],
      :bucket => ENV['AWS_BUCKET']
    }
  }
```

The settings will most likely be the same, unless you use different buckets or 
regions.

Create a file called `paperclip.rb` inside of `config/initializers`. Files in 
initializers get run once when your app boots up. So if you change it, restart
your server!

```rb
# config/initializers/paperclip.rb
Paperclip::Attachment.default_options[:url] = ":s3_domain_url"
Paperclip::Attachment.default_options[:path] = "/:class/:attachment/:id_partition/:style/:filename"

```

