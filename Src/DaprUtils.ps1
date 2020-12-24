# This function is used to collect the app name, name with .exe and any alias defined for the
# app to build a regular expression. If the expression finds a match the tab expansion will
# be applied
function Get-AliasPattern {
   param(
      [string] $exe
   )

   process {
      $aliases = @($exe) + @("$exe.exe") + @(Get-Alias | Where-Object { $_.Definition -eq $exe } | Select-Object -Exp Name)

      "($($aliases -join '|'))"
   }
}