home-page
=========

single page with html editor and redis datastore

## config

This app will be looking for a file 

config/secrets.yml

```ruby

user: phish
password: whatever

datastore:
  development:
    host: 127.0.0.1
    port: 6379
    login:
    password:

  production:
    host: pub-non.us-east1.ec2.ntiadata.com
    login: rediscloud
    password: tjfasdfasdfasdfasdf41
    port: 19027

```
