# Playground for Tailscale + Caddy + devenv

Set up auth:

```
echo 'export TS_AUTH_KEY=<key>' > .env
```

Launch the processes:

```
devenv up
```

Visit `http://caddy.<you>.ts.net`.
Each link is also a separate node on `http://<node>.<you>.ts.net`.
