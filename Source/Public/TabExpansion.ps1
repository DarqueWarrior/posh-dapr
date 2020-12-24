$PowerTab_RegisterTabExpansion = if (Get-Module -Name powertab) {
   Get-Command Register-TabExpansion -Module powertab -ErrorAction SilentlyContinue
}

if ($PowerTab_RegisterTabExpansion) {
   & $PowerTab_RegisterTabExpansion "dapr.exe" -Type Command {
      param($Context, [ref]$TabExpansionHasOutput)

      $line = $Context.Line
      $lastBlock = [regex]::Split($line, '[|;]')[-1].TrimStart()
      $TabExpansionHasOutput.Value = $true
      DaprTabExpansion $lastBlock
   }
   return
}

if (Test-Path Function:\TabExpansion) {
   Rename-Item Function:\TabExpansion TabExpansionBackup
}

# Set up tab expansion and include dapr expansion
# This needs to be last in this file
function TabExpansion {
   [CmdletBinding()]
   param(
      [string] $line,

      [string] $lastWord
   )

   process {
      $lastBlock = [regex]::Split($line, '[|;]')[-1]

      switch -regex ($lastBlock) {
         "^$(Get-AliasPattern dapr) (.*)" { DaprTabExpansion $lastBlock }

         # Fall back on existing tab expansion
         default { if (Test-Path Function:\TabExpansionBackup) { TabExpansionBackup $line $lastWord } }
      }
   }
}