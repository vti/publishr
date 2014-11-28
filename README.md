# Publishr

Allows updating status on several social networks.

## Preparing message

Mesage is a text file:

```
Status: New article is out
Link: http://mywebsite.com
Image: /path/to/image

Just a long text
with
multilines...
```

Depending on the channel various information is used. For example for twitter
the status, link and image are used and for facebook everything combined. And so
on.

## Configuring access

Access is configured via a JSON file:

```
# Comments are supported

{
# Twitter configuration
#   "twitter": {
#       "consumer_key":"",
#       "consumer_secret":"",
#       "access_token" : "",
#       "access_token_secret" : ""
#   }
}
```

Every object's key is a service with its configuration.

## Publishing

By default the config file is name `publishr.json` and is searched within
a current working directory. To overwrite path to config file use `--config`
option.

```
perl script/publishr message.txt
perl script/publishr --config another-config.json message.txt
```

## Publishing only to specific channel

If you want to publish only to a specific social network, just use `--channel`
option:

```
perl script/publishr --channel twitter message.txt
```

## Getting access tokens

### Twitter

Has to be done once.

1. Register your application via <https://apps.twitter.com/>.
2. Get your consumer and access tokens from
   <https://apps.twitter.com/app/[APP_ID]/keys>.
   Here you may have to confirm your phone number, only then Twitter will allow
   you to update statuses within an application.
3. Save `consumer_key`, `consumer_secret`, `access_token`,
   `access_token_secret`.

### Facebook

Has to be done every two months.

1. Create your application via <https://developers.facebook.com/apps>.
2. Visit API Explorer <https://developers.facebook.com/tools/explorer/>.
3. Generate Access Token previously selecting your app.
4. Create a long-term token visiting
   <https://graph.facebook.com/oauth/access_token?client_id=[APP_ID]&client_secret=[APP_SECRET]&grant_type=fb_exchange_token&fb_exchange_token=[ACCESS_TOKEN]>
5. Save `app_id`, `secret`, `access_token` and `group_id`.

## VK

Has to be done once.

1. Create your application via <http://vk.com/apps?act=manage>.
2. Get a token visiting
   <https://oauth.vk.com/authorize?client_id={APP_ID}&scope=wall,photos&redirect_uri=http://oauth.vk.com/blank.html&display=page&response_type=token>
3. Discover your user id.
3. Save `acess_token` and `user_id`.