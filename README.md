# CatalogueCanvas Home Assistant Add-on

A Home Assistant add-on that runs [CatalogueCanvas](https://github.com/CatalogueCanvas/CatalogueCanvas),
a self-hosted manager for your creative files (artwork, generative code, design
assets) organised into catalogues and portfolios.

## Add this repository to Home Assistant

1. In Home Assistant, go to **Settings → Add-ons → Add-on Store**.
2. Open the ⋮ menu (top right) and pick **Repositories**.
3. Paste this repository's URL and click **Add**:

   ```
   https://github.com/CatalogueCanvas/cataloguecanvas-homeassistant-addon
   ```

4. Close the dialog. **CatalogueCanvas** now shows up in the store.
5. Install it, set an admin password on the Configuration tab, and start it.

Once it's running, open `http://<your-ha-host>:8000` and log in.

The full setup and configuration notes are in
[`cataloguecanvas/DOCS.md`](cataloguecanvas/DOCS.md).
