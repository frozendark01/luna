<p align="center"><img src="docs/logo.png"></p>
<h1 align="center">Luna </h1> <br/ >
<p align="center">fork from Glance </p>
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

### Problem Statement
Previously, when a monitored service changed status, users had to manually refresh the page to see the updated state. This created a poor user experience for services with frequently changing states.

### Solution for monitoring services eg: DNS, TCP/HTTP/ICMP
Implemented a push-based real-time notification system using:

* Server-Sent Events (SSE) for bidirectional server-to-client communication
* Background monitoring worker that polls service status at regular intervals
* Event debouncing to prevent notification spam during service flapping
* Partial DOM updates to efficiently refresh only affected widgets
* Guard mechanisms to prevent duplicate initialization of UI components
* More detailes - LIVE_EVENTS_IMPLEMENTATION •
* Docker compose using provided directory structure (recommended)

### Solution for monitoring services eg: custopm-api widgets
* Added recursive polling that dives into container widgets (groups, split-columns)
* Polls monitor and custom-api widgets every 15 seconds
* Detects content changes and emits events
* Custom-api widget change detection (widget-custom-api.go):
* Added PrevCompiledHTML field to track previous content
* Compares rendered HTML to detect changes
* Emits custom-api:data_changed event when changes detected
* Event hub with caching (events.go):

* Server-Sent Events broadcast to connected clients
* Event caching: Stores recent events for reconnecting clients
* Debouncing per widget to prevent event spam
* Robust numeric type handling for widget IDs
* Browser-side DOM updates (page.js):

* Listens for custom-api:data_changed events
* Fetches updated widget HTML via /api/widgets/{id}/content/
* Replaces widget DOM with new content
* Re-initializes all widget setup functions
* Widget registration fix:

* Widgets inside containers are now registered in widgetByID map
* Allows endpoint to fetch child widgets by ID


### Install Galance

Create a new directory called `luna` and add luna.yml file in the directory
When ready, run:

```bash
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

This is a fork of luna Dashboard with Live-Events. No manual refresh needed!
