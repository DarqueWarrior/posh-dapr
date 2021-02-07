# This function is used to collect the app name, name with .exe and any alias defined for the
# app to build a regular expression. If the expression finds a match the tab expansion will
# be applied
function Get-DaprAliasPattern {
   [CmdletBinding()]
   [OutputType([string])]
   param(
      [string] $exe
   )

   process {
      $aliases = @($exe) + @("$exe.exe") + @(Get-Alias | Where-Object { $_.Definition -eq $exe } | Select-Object -Exp Name)

      # Also include dapr - and dapr -- or you will not be able to expand flags
      # for dapr by its self
      foreach ($alias in $aliases) {
         $aliases += "$alias -"
         $aliases += "$alias --"
      }

      "($($aliases -join '|'))"
   }
}

# Wrapped calls to dapr so they can be mocked in unit tests
function _callDapr {
   [CmdletBinding()]
   param(
      [string] $cmd,

      [string] $subCmd,

      [switch] $getHelp
   )

   process {

      # Sometimes flags are passed in as sub command. To protect
      # just test if the sub command starts with a -. If so just
      # null it out because it is a flag an not sub command.
      if ($subCmd -like "-*") {
         $subCmd = $null
      }

      # When the sub command is null and we want help is a special case when
      # you are trying to use a flag off of dapr itself. So don't call dapr
      # help dapr. Just call dapr
      if ($getHelp.IsPresent -and "" -eq $subCmd) {
         # We are not calling dapr help because there is a bug where the
         # -v, --version flags are not shown. The only way to see them
         # is to call dapr with no arguments.
         return dapr
      }

      if ($getHelp.IsPresent) {
         return dapr help $cmd $subCmd
      }
      else {
         return dapr $cmd
      }
   }
}