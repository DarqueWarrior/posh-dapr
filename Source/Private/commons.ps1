# This function is used to collect the app name, name with .exe and any alias defined for the
# app to build a regular expression. If the expression finds a match the tab expansion will
# be applied
function Get-AliasPattern {
   [CmdletBinding()]
   [OutputType([string])]
   param(
      [string] $exe
   )

   process {
      $aliases = @($exe) + @("$exe.exe") + @(Get-Alias | Where-Object { $_.Definition -eq $exe } | Select-Object -Exp Name)

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
      if ($getHelp.IsPresent) {
         return dapr help $cmd $subCmd
      }
      else {
         return dapr $cmd
      }
   }
}