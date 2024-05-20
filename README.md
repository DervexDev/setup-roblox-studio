# Setup Roblox Studio

This simple GitHub Action allows you to install Roblox Studio that you can use in your CI/CD workflow.

## Supported OSes

Currently only **macOS** is supported for two reasons:

- **Windows** runners are significantly slower so there is no reason to use them
- Roblox Studio is not officially sported on **Linux**

## Authentication

To use Roblox Studio you still have to log in. This can be done by updating `~/Library/HTTPStorages/com.Roblox.RobloxStudio.binarycookies` file with your `.ROBLOSECURITY` token.
