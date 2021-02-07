# posh-dapr

posh-dapr provides tab completion that goes beyond that supported by the `dapr completion` command that comes with Dapr.

posh-dapr lets you tab complete sub commands, flags, runtime versions, and instance names. It also supports filtered completion. For example, with posh-dapr, PowerShell can tab complete dapr commands like `stop` by type `dapr st` and pressing the <kbd>tab</kbd> key twice. If you continue to press <kbd>tab</kbd> you will cycle between the `status` and `stop` commands.

posh-dapr can complete instance names for the `stop` command. For example, you can type `dapr stop` and pressing the <kbd>tab</kbd> to cycle through all the running instances of dapr.

posh-dapr can complete runtime versions. For example, you can type `dapr init --runtime-version` and pressing the <kbd>tab</kbd> to cycle through all the release of the dapr runtime.

## install

```powershell
Install-Module -Name posh-dapr
```

Based on work by

- Keith Dahlby, <http://solutionizing.net/>
- Mark Embling, <http://www.markembling.info/>
- Jeremy Skinner, <http://www.jeremyskinner.co.uk/>
