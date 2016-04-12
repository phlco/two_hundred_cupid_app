# Uploading images with paperclip!

###SWBAT
*Explain why we use 'paperclip'<br>
*Use paperclip to upload images for a model

##What is paperclip?
"For some reason, file attachment is annoying. I don’t know why, and I know a lot of people have attempted to solve the problem in the past, myself included. Yet it still is. Having gotten fed up with gotchas and design decisions that we didn’t agree with, I went and wrote Paperclip on the plane to RailsConf last year. We’ve been using it here in various forms since and IMHO it’s the way to handle uploads, and finally decided that it should be released." -- John Yurek, Thoughbot, March 2008 

With paperclip, a file is treated like any other attribute. It’s assigned like any other attribute. You can say what thumbnails are made, and what resolution and format they are, and where they should be stored.

So why use paperclip? <strong>It makes uploading files (e.g. images) very simple.</strong>

## It's a RAILS SPEED ROUND!
Pair program a simple rails app. 
The requirements are as follows:<br>
*1)There is a Post model with title (string) and body (text) as attributes<br>
*2)There is a posts controller with index, new, and create actions that work<br>
*3)There is an index page that displays all the posts<br>
*4)There is a new page that let's you create a new post<br>
*5)There is a navbar on every page that let's you navigate between the index page and the new page. <br>
*6)There is a routes file (you can use the resources function if you want)<br>


## Let's add images to the posts!

###Step 1 - load up Paperclip
Add paperclip to our list of gems, then load it into our app with a ```bundle```

```rb
# Gemfile
gem 'paperclip'
```

```bash
$ bundle
```


###Step 2 - let our database know what it will be storing

Right now our database is only storing the title and body attributes of each post. We should run a migration to add some image properties to the DB. <br><br>
Let's make an empty migration, then we can add stuff to it, and once we're done we can run ```rake db:migrate```

```bash
$ rails g migration AddPaperclipToPost
```

```rb
# db/migrate/20150603054166234_add_paperclip_to_post.rb
class AddPaperclipToPost < ActiveRecord::Migration
  def change
    add_attachment :posts, :image  
  end
end
```

```add_attachment``` is a special Paperclip method that says we want to change the posts table so that we can add an attachment to each post (which we are calling 'image'). Run this migration, then take a look at our schema.

```bash
$ rake db:migrate
```

Check out those schema!

```rb
# db/schema.rb
ActiveRecord::Schema.define(version: 20150602054116) do

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"     # <-- look what got added
    t.string   "image_content_type"  # <-- look what got added!
    t.integer  "image_file_size"     # <-- look what got added!
    t.datetime "image_updated_at"    # <-- look what got added!
  end

end
```

###Step 3 - Tell our model that its objects have attached files
In our Post model let's tell it that posts will have an attached file (called image). When we want to refer to that file, we might want the small version, the med version, or the large version. We can define that here too. 

```rb
# models/post.rb
class Post < ActiveRecord::Base
  has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" }
end
```

[http://www.rubydoc.info/gems/paperclip/Paperclip/ClassMethods]


<br>
While we're here, let's also do something else. The new version of Paperclip is secure by default. You have to specify which file types you are going to allow to be uploaded. This is to prevent 'content type spoofing', e.g. uploading a php file instead of an image which will then become publicly accessible. 

WHich file types shall we allow? jpgs, pngs, gifs seem ok. 

```rb
# models/post.rb
class Post < ActiveRecord::Base
  has_attached_file :image, styles: { small: "64x64", med: "100x100", large: "200x200" }
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
end
```

[https://github.com/thoughtbot/paperclip#security-validations]


Speaking of security, there's one more thing we need to do - let the image part of the params through for when we want to save an image!

```rb
# controllers/posts_controller.rb
  private
  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
```

###Step 4 - Fiddle with the view templates

Now we need to make sure the form for a new post allows us to upload a file:

```erb
<!-- views/posts/new.html.erb -->
<h1>Make a new post!</h1>

<%= form_for @post do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title %>

  <%= f.label :body %>
  <%= f.text_area :body%>

  <!-- This generates <input type="file"> -->
  <%= f.label :image %>
  <%= f.file_field :image%>

  <%= f.submit %>

<% end %>
```

...and that we can see the image in the index page:

```erb
<!-- views/posts/index.html.erb -->
<h1>This page lists all posts</h1>
<hr>
<% @posts.each do |post| %>
  <%= post.title %><br>
  <%= post.body %><br>
  <%= image_tag post.image.url(:large) %><br><hr>
<% end %>
```

##Now you do it! (10 mins)
*Make sure you have a copy of this to play with: https://github.com/ga-students/WDI_LA_16/tree/master/06-week/blog_authentication/blog_with_authentication-COMPLETE
*Add image upload to the User model
*Show a thumbnail of the image next to each post on the index page
*Pat yourself on the back


