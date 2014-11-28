# Publishr

Allows updating status on several social networks.

## Preparing message

Mesage is a JSON file:

```
{
    "title" : "Hello there!"
}
```

## Configuring access

Access is configured via a JSON file too:

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
perl script/publishr message.json
perl script/publishr --config another-config.json message.json
```

## Publishing only to specific channel

If you want to publish only to a specific social network, just use `--channel`
option:

```
perl script/publishr --channel twitter message.json
```
