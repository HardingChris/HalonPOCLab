# Halon configuration template (ssh)

## Getting started

1. Follow the [instructions](https://docs.halon.io/manual/install.html#installation) in our manual to add our package repository on the remote machine and then install the `halon` package
2. Move this folder to the remote machine (You don't need to have it on your local machine)
3. Install [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension
4. [Connect to the remote machine](https://code.visualstudio.com/docs/remote/ssh#_connect-to-a-remote-host) using the [Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension
5. [Install](https://code.visualstudio.com/docs/remote/ssh#_managing-extensions) [Halon Configuration Packer](https://marketplace.visualstudio.com/items?itemName=Halon.vscode-halon) extension, [Halon Scripting Language Linter](https://marketplace.visualstudio.com/items?itemName=Halon.hsl-linter) extension and [Halon Scripting Language Debugger](https://marketplace.visualstudio.com/items?itemName=Halon.hsl-debug) extension on the remote machine (if they are not already installed)
6. [Open this folder on the remote machine](https://code.visualstudio.com/docs/remote/ssh#_connect-to-a-remote-host)


# Environment variables and secrets
## DKIM keys
Config uses \files\dkim\<emaildomain>.key file for each smtpdomain that contains private and public key that will be used for dkim signing - these are excluded from git and should be added to the server locally.

