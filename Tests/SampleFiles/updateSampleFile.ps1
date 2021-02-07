# This file is used to update the sample files as new versions of dapr are
# released.
# This will walk through the existing files, issue the help command and update
# with the latest information.
[CmdletBinding()]
param()

process {
   $output = dapr --help
   $cmds = foreach ($cmd in $output) {
      if ($cmd -match '^  (?<cmd>[a-z]+) +[^[]') {
         $matches['cmd']
      }
   }

   Write-host "# $(dapr --version | Select-Object -Skip 0 -First 1)"
   $output > "dapr_help.txt"
   Write-Host "Mock _callDapr { Get-Content ""`$sampleFiles\dapr_help.txt"" } -ParameterFilter { `$cmd -eq 'help' }"

   foreach ($cmd in $cmds) {
      dapr $cmd --help > "dapr_help_$cmd.txt"
      Write-Host "Mock _callDapr { Get-Content ""`$sampleFiles\dapr_help_$cmd.txt"" } -ParameterFilter { `$cmd -eq '$cmd' -and `$getHelp -eq `$true }"

      # Process sub commands
      $startMatching = $false
      $output = dapr $cmd --help

      foreach ($line in $output) {
         if ($line -match 'Available Commands:') {
            $startMatching = $true
         }
         elseif ($line -match 'Flags:') {
            $startMatching = $false
         }

         if (-not $startMatching) {
            continue
         }

         if ($line -match '^  (?<subCmd>\S+)') {
            $subCmd = $matches['subCmd']
            $sc = $subCmd.Trim()

            dapr $cmd $sc --help > "dapr_help_$($cmd)_$sc.txt"
            Write-Host "Mock _callDapr { Get-Content ""`$sampleFiles\dapr_help_$($cmd)_$sc.txt"" } -ParameterFilter { `$cmd -eq '$cmd' -and `$subCmd -eq '$sc' -and `$getHelp -eq `$true }"
         }
      }
   }
}