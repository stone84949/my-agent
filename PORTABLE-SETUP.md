# Popebot Portable Setup

This repo now supports a simple clone-and-click workflow for moving your Popebot to another PC.

## Main workflow

On your main PC:

1. Double-click `refresh-portable-config.bat`
2. Commit and push the updated `portable-config/my-agent-portable.zip`

On a new PC:

1. Clone this repo
2. Double-click `setup-new-pc.bat`

That restore flow will:

- restore `.env`
- restore your skills, agents, and custom helper folders
- restore soul, cron, and trigger config
- restore LiteLLM and Traefik config
- recreate desktop shortcuts
- start thepopebot

## Files that matter

- `refresh-portable-config.bat`
  Creates the current machine snapshot for GitHub
- `setup-new-pc.bat`
  Restores that snapshot into a fresh clone and starts the bot
- `export-portable-config.ps1`
  Builds the portable zip
- `restore-portable-config.ps1`
  Unpacks the portable zip into the clone
- `start-agent.bat`
  Starts the stack and waits until the bot responds before opening the browser

## Important note about secrets

`portable-config/my-agent-portable.zip` can include your `.env` secrets.

Use this only in a private repo you control.

If you ever want a safer public-repo version later, the next upgrade would be:

- keep the zip out of Git
- store secrets separately
- restore the non-secret config from Git and the secrets from a private file or password manager
