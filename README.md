<p align="center"><img src="docs/logo.png"></p>
<h1 align="center">Luna </h1> <br/ >
<p align="center"> • fork from Glance •</p>
<p align="center">
  <a href="#installation">Install</a> •
  <a href="docs/configuration.md#configuring-luna">Configuration</a> •

</p>
<p align="center">
  <a href="https://github.com/frozendark01/luna/docs/LIVE_EVENTS_IMPLEMENTATION.md">New : Live Events Implementation</a> •
  <a href="https://github.com/frozendark01/community-widgets">Community widgets</a> •
  <a href="docs/preconfigured-pages.md">Preconfigured pages</a> •
  <a href="docs/themes.md">Themes</a>
</p>

<p align="center">Luna is a lightweight, open-source dashboard for homelabs and infrastructure.<br> simple. fast. open.</p>

![](docs/images/readme-main-image.png)


### Install Galance
### Docker Install
Create a new directory called `config` and add `luna.yml` file in the directory

```yaml
services:
  luna:
    image: ghcr.io/frozendark01/luna:main
    container_name: luna
    restart: unless-stopped
    # If you need luna to see services running directly on the host (e.g. DNS on port 53)
      # you can use network_mode: host or add-host
    ports:
      - "8080:8080"
    volumes:
      - ./config:/app/config:ro # add luna.yml to config folder
      # If you have custom assets (CSS/JS) that you want to test without rebuilding
      # - ./public:/app/public:ro
    environment:
      - TZ=Etc/UTC
      - luna_CONFIG=/app/luna.yml
    # Important for SSE (Live Events) data flow
    logging:
      driver: "json-file"
      options:
        max-size: "10mb"
        max-file: "3"
```
```bash
docker compose up -d
```
### Update Luna
```bash
docker compose down
docker compose pull
docker compose up -d
```
### Luna Installation on Linux environment (LXC, VPS, or Bare Metal).
run:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/frozendark01/luna/main/ct/luna.sh)"
```
** To update the lates build just type update.

