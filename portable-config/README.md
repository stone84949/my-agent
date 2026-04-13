# Portable Config

This folder is for your one-click machine restore bundle.

Typical flow:

1. On your main PC, run `refresh-portable-config.bat`
2. Commit the updated `my-agent-portable.zip` to your private GitHub repo
3. On a new PC, clone the repo
4. Double-click `setup-new-pc.bat`

That restore script will:

- overlay your `.env`
- restore your skills, agents, soul, cron, trigger, and LiteLLM config
- restore helper folders such as `.claude`, `.omc`, and `.pi`
- recreate desktop shortcuts
- start thepopebot

Important:

- This bundle can contain secrets from `.env`
- Only store it in a private repo you control
- If you do not want secrets in Git, keep the zip out of Git and copy it over manually instead
