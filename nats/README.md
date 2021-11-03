# [NATS](https://nats.io/)


## [Installing](https://docs.nats.io/nats-server/installation#installing-via-docker)

```bash
docker pull nats:latest
docker run -p 4222:4222 -ti nats:latest
```


## [Connecting](https://docs.nats.io/developing-with-nats/connecting/default_server)

Install [natscli](https://github.com/nats-io/natscli)
```bash
brew tap nats-io/nats-tools
brew install nats-io/nats-tools/nats
```

Create a configuration, add a context, and list contexts
```bash
nats context add local --description "Localhost" --select
nats context ls
```

Subscribe
```bash
nats sub cli.demo
```

Publish
```bash
# Single message
nats pub cli.demo "hello world"
# Counter and timestamp
nats pub cli.demo "message {{.Count}} @ {{.TimeStamp}}" --count=10
# From stdin
echo hello | nats pub cli.demo
# Headers (meta data)
nats pub cli.demo 'hello headers' -H Header1:One -H Header2:Two
```


## [Jetstream](https://docs.nats.io/jetstream/jetstream)

Start `nats-server` with jetstream enabled
```bash
docker run --network host -p 4222:4222 nats -js
```

NOTE The `nats` utility is also available inside the container
```bash
docker run -ti --network host natsio/nats-box
```


