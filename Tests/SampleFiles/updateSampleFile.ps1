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

   foreach ($cmd in $cmds) {
      dapr $cmd --help > "dapr_help_$cmd.txt"
   }
}