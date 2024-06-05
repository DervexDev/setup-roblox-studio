# Setup Roblox Studio

This simple GitHub Action allows you to install Roblox Studio that you can use in your CI/CD workflow.

## Supported OSes

Currently only **macOS** is supported for two reasons:

- **Windows** runners are significantly slower so there is no reason to use them
- Roblox Studio is not officially sported on **Linux**

## Authentication

To use Roblox Studio you still have to log in. You can do that by providing `login` and `password` inputs.

> [!WARNING]
> Login process is experimental and has one important drawback - **you can't log in to the account with 2-step verification enabled**.

## Inputs

| Name      | Default | Description                                                       |
| --------- | ------- | ----------------------------------------------------------------- |
| login     | `""`    | Your account username/email/phone                                 |
| password  | `""`    | Your account password                                             |
| keep-open | `false` | Whether to keep Roblox Studio open after installation is complete |
