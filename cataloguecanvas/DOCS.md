# CatalogueCanvas documentation

## Installation

1. Add this repository to Home Assistant: **Settings → Add-ons → Add-on Store →
   ⋮ → Repositories**, then paste the repository URL.
2. Install **CatalogueCanvas** from the store.
3. Open the **Configuration** tab and set an **Admin password**. Until you do, the
   app fails closed and nobody can log in.
4. Start the add-on and open `http://<your-ha-host>:8000`.

## Why there's no sidebar panel

Ingress (the thing that puts add-ons in the sidebar) works by loading the add-on's
UI in an iframe under a path prefix. CatalogueCanvas won't cooperate with either
half of that. It sends `X-Frame-Options: DENY` and a `Content-Security-Policy` of
`frame-ancestors 'none'`, which block the iframe outright, and its frontend hard-codes
absolute URLs with no base path to configure. So the add-on skips Ingress and just
serves the app on port 8000.

## Configuration options

| Option | Required | Default | Description |
|--------|----------|---------|-------------|
| `admin_password` | Yes | *(empty)* | Admin login password. No login is possible until set. |
| `admin_username` | No | `admin` | Admin account username. |
| `site_title` | No | `CatalogueCanvas` | Name shown in the UI and public portfolios. |
| `site_author` | No | *(empty)* | Author attribution on public portfolios. |
| `cookie_secure` | No | `false` | Keep off for plain-HTTP LAN access. Turn on only behind HTTPS. |
| `llm_allowed_hosts` | No | *(empty)* | Comma-separated hostnames the LLM feature may contact (SSRF guard). |
| `max_upload_bytes` | No | `1073741824` | Largest single asset upload, in bytes (default 1 GiB). |

## Data & backups

Everything the app stores lives in the add-on's private `/data` volume: the SQLite
database (`catalogue.db`), your uploaded assets (`storage/`), and a session key
(`secret.key`) it generates on first boot. Home Assistant backups cover this volume,
so backing up the add-on captures the lot.

## Pointing libraries at host media

A **library** in CatalogueCanvas is just a directory path inside the container. The
app checks that the path exists, is a directory, and is writable before it accepts
it. To use media that's already on your Home Assistant host, the add-on mounts these
host folders into the container:

| Host folder | In-container path | Access |
|-------------|-------------------|--------|
| Media       | `/media`          | read/write |
| Share       | `/share`          | read/write |
| HA config   | `/homeassistant`  | read-only |

So in the UI, point a library at something like `/media/artwork` or
`/share/catalogue`. Make the sub-directory on the host first (the Samba or File
editor add-on both work) so the path is actually there when the app looks.

> `/homeassistant` is read-only, so you can't put a library there. It's mounted for
> reference only.

## Networking

The web UI is on port `8000`. You can remap or turn off the host port under the
add-on's **Network** settings. This is plain HTTP over your LAN, so leave
`cookie_secure` off unless you've put the add-on behind an HTTPS reverse proxy.
