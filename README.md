# OLSPanel Webmail Plugin Pack

Adds Snappymail and SOGo launcher plugins to OLSPanel.

## What this package installs

- Snappymail app files under `/usr/local/olspanel/mypanel/3rdparty/snappymail`
- Snappymail bridge launcher `auto_index.php`
- SOGo bridge launcher `auto_index.php`
- Plugin configs:
  - `plugin/snappymail.conf`
  - `plugin/sogo.conf`
- Icons:
  - Snappymail: `https://www.cloudron.io/store/icons/snappymail.png`
  - SOGo: `https://www.sogo.nu/img/sogo.svg`

## Install on a VPS

```bash
cd /root/olspanelwebmail
chmod +x scripts/install-webmail-plugins.sh
sudo bash scripts/install-webmail-plugins.sh
```

If your panel path is different, set `OLSPANEL_BASE_DIR`:

```bash
sudo OLSPANEL_BASE_DIR=/custom/path/to/mypanel bash scripts/install-webmail-plugins.sh
```

## Notes

- The plugin link for SOGo points to `/3rdparty/sogo/auto_index.php` (not `/SOGo/`) to avoid panel 404s when no `/SOGo/` route exists.
- To use full SOGo webmail, you still need a running SOGo backend and proxy target.
- `SOGO_TARGET_URL` can be set in environment for custom SOGo login target.

## Quick checks

```bash
curl -k -I https://127.0.0.1:2083/3rdparty/snappymail/auto_index.php
curl -k -I https://127.0.0.1:2083/3rdparty/sogo/auto_index.php
```

Expected before login: `302` to `/login/`.
