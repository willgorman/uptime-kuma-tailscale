# Uptime-Kuma with Tailscale

Run [Uptime-Kuma](https://github.com/louislam/uptime-kuma) on [Fly.io](https://fly.io) with [Tailscale](https://tailscale.com) support.

## Features
- Persistent storage using Fly volumes
- Tailscale integration for private network monitoring
- Optional exit node capability

## Deployment

1. Install the [Fly CLI](https://fly.io/docs/flyctl/install/)
2. Clone this repository
3. Create a new app on Fly.io:
   ```bash
   fly launch
   ```
4. Create a volume for persistent storage:
   ```bash
   fly volumes create appstate --size 1
   ```
5. Set your environment variables:
   ```bash
   fly secrets set TAILSCALE_AUTHKEY=your-auth-key
   ```
6. Deploy the app:
   ```bash
   fly deploy
   ```

## Environment Variables
- TAILSCALE_AUTHKEY (optional): Your tailscale authkey [more info](https://login.tailscale.com/admin/settings/keys)
- TAILSCALE_HOSTNAME (optional): The hostname for your tailscale instance
- ONLY_TAILSCALE (optional): If set to true, the app will only be accessible through tailscale
- TAILSCALE_EXITNODE (optional): If set, tailscale will advertise this instance as an exit node [more info](https://tailscale.com/kb/1103/exit-nodes/)

## Disclaimer
I am not affiliated with Uptime-Kuma, Fly.io, or Tailscale in any way. This is an independent implementation for personal use shared with the community.