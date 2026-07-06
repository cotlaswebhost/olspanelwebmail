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

## Update in one command

```bash
cd /root/olspanelwebmail
sudo bash scripts/update-webmail-plugins.sh
```

What it does:
- Pulls latest repo changes with `git pull --ff-only` when this folder is a git checkout.
- Runs `scripts/install-webmail-plugins.sh` to apply the latest plugin files.

## Uninstall

Interactive uninstall:

```bash
cd /root/olspanelwebmail
sudo bash scripts/uninstall-webmail-plugins.sh
```

Non-interactive uninstall:

```bash
cd /root/olspanelwebmail
sudo bash scripts/uninstall-webmail-plugins.sh --yes
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
