# CatalogueCanvas

![CatalogueCanvas](logo.png)

A self-hosted place to organise your creative files (artwork, generative code,
design assets, whatever) into catalogues and portfolios. No external accounts,
nothing in the cloud.

It's a FastAPI backend with a React frontend and a SQLite database. Everything you
upload lives in the add-on's `/data` volume. That means it survives restarts, and
Home Assistant backups pick it up automatically.

## Access

The web UI runs on port 8000. Start the add-on, then open
`http://<your-ha-host>:8000` and log in with the admin password you set on the
Configuration tab.

One thing to know up front: it won't appear in the Home Assistant sidebar. The
upstream app refuses to load inside an iframe, so you reach it directly on its
port instead. DOCS.md has the full reason.

## Quick start

1. Install the add-on.
2. On the Configuration tab, set an admin password. You need this. There's no
   login without it.
3. Start the add-on.
4. Open `http://<your-ha-host>:8000` and log in.

To point a library at media already sitting on your host (`/media`, `/share`),
see DOCS.md.
