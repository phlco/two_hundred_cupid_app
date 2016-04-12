# TwoHundred Cupid

What Environment are we in?

You can set environmental variables in your bash profile.

Setting keys in development!

Open your bash profile with sublime

```
$ subl ~/.bash_profile
```

Then add an environmental variable

```
export FISH=salmon
```

> Remember to restart your terminal!

You can access environmental variables in your Rails app
with `ENV`

```
ENV["FISH"]
```

Setting keys in production on heroku!

```
heroku config:add FISH=trout
```

# Further work

Adding images via [PaperClip](paperclip.md) and storing them on [Amazon S3](amazon_s3.md)
