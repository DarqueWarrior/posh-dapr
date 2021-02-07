$script:daprCommands = @()

# By default the dapr command list is populated the first time daprCommands is invoked.
# Invoke PopulateDaprCommands in your profile if you don't want the initial hit.
function PopulateDaprCommands {
   [CmdletBinding()]
   param()

   process {
      $output = _callDapr -cmd help
      $cmds = foreach ($cmd in $output) {
         if ($cmd -match '^  (?<cmd>[a-z]+) +[^[]') {
            $matches['cmd']
         }
      }

      $script:daprCommands = $cmds
   }
}

function DaprTabExpansion {
   param(
      [string] $lastBlock
   )

   process {
      switch -regex ($lastBlock) {

         # handles dapr <cmd> -<option> value -<option> ...
         'dapr(\.exe)* (?<cmd>\S+) ((?<subCmd>\S+) |((-{1,2})(\S+) \S+ ))*(-{1,2})(?<filter>\S*)$' {
            findDaprFlags -currentLine $matches[0] -cmd $matches['cmd'] -subCmd $matches['subCmd'] -filter $matches['filter']
            break
         }

         # handles dapr stop <dapr instance>
         # handles dapr stop -a <dapr instance>
         # handles dapr stop -app-id <dapr instance>
         'dapr(\.exe)* stop (-a |--app-id )*(?<filter>\S*)$' {
            findDaprInstances -filter $matches['filter']
            break
         }

         # handles dapr init --runtime-version <dapr release>
         'dapr(\.exe)* init (--runtime-version )*(?<filter>\S*)$' {
            findDaprReleases -filter $matches['filter']
            break;
         }

         # handles dapr <cmd>
         # handles dapr cmd <subCommnad>
         # handles dapr help <cmd>
         # handles dapr help cmd <subCommnad>
         'dapr(\.exe)* (help )?((?<cmd>\S+) )*(?<filter>\S*)$' {
            if ($matches['cmd']) {
               findDaprSubCommands -cmd $matches['cmd'] -filter $matches['filter']
            }
            else {
               findDaprCommands -filter $matches['filter']
            }
            break
         }

         # handles dapr cmd <subCommnad>
         'dapr(\.exe)* (?<cmd>\S+) (?<filter>\S*)$' {
            findDaprSubCommands -cmd $matches['cmd'] -filter $matches['filter']
            break
         }
      }
   }
}

function findDaprReleases {
   param(
      [string] $filter
   )

   process {
      $filter = $filter.Trim()
      $output = Invoke-RestMethod -Uri 'https://api.github.com/repos/dapr/dapr/releases'
      $daprReleases = foreach ($i in $output.tag_name) {
         # The release starts with a v but we don't want that.
         if ($i -match 'v(?<release>.+)') {
            $release = $matches['release']

            if ($filter -and $release.StartsWith($filter, 'CurrentCultureIgnoreCase')) {
               $release
            }
            elseif (-not $filter) {
               $release
            }
         }
      }

      $daprReleases
   }
}

function findDaprInstances {
   param(
      [string] $filter
   )

   process {
      $filter = $filter.Trim()
      $output = _callDapr -cmd list
      $daprInstances = foreach ($i in $output) {
         # The id is followed by the http, gRPC and App port
         # with the latest version RC2 there are results that
         # don't have a appid but 0 for all the ports. We don't
         # want to return them. So check if the value is 0
         if ($i -match '(?<instance>[^ ]+) +[0-9]') {
            $instance = $matches['instance']

            if ($instance -eq "0") {
               continue
            }

            if ($filter -and $instance.StartsWith($filter, 'CurrentCultureIgnoreCase')) {
               $instance
            }
            elseif (-not $filter) {
               $instance
            }
         }
      }

      $daprInstances
   }
}

function findDaprSubCommands {
   param(
      [string] $cmd,

      [string] $filter
   )

   $subCmds = @()
   $startMatching = $false
   $output = _callDapr -cmd $cmd -getHelp

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

         # Skip if it is already on the current line
         if ($null -ne $(Select-String -InputObject $currentLine -Pattern $subCmd)) {
            continue
         }

         if ($filter -and $subCmd.StartsWith($filter)) {
            $subCmds += $subCmd.Trim()
         }
         elseif (-not $filter) {
            $subCmds += $subCmd.Trim()
         }
      }
   }

   $subCmds | Sort-Object
}

# By default the dapr command list is populated the first time daprCommands is invoked.
# Invoke PopulateDaprCommands in your profile if you don't want the initial hit.
function findDaprCommands {
   param(
      [string] $filter
   )

   process {
      if ($script:daprCommands.Length -eq 0) {
         PopulateDaprCommands
      }

      if ($filter) {
         $script:daprCommands | Where-Object { $_.StartsWith($filter) } | ForEach-Object { $_.Trim() } | Sort-Object
      }
      else {
         $script:daprCommands | ForEach-Object { $_.Trim() } | Sort-Object
      }
   }
}

function findDaprFlags {
   param(
      # Contains all the text on the current line. This is used to remove
      # and flags that have already been used in ths command
      [string] $currentLine,

      [string] $cmd,

      [string] $subCmd,

      [string] $filter
   )

   process {
      $flags = @()

      $output = _callDapr -cmd $cmd -subCmd $subCmd -getHelp

      foreach ($line in $output) {
         if ($line -match '^ +(-[a-zA-Z], )*--(?<flag>\S+)') {
            $flag = $matches['flag']

            # Skip if it is already on the current line
            if ($null -ne $(Select-String -InputObject $currentLine -Pattern $flag)) {
               continue
            }

            if ($filter -and $flag.StartsWith($filter)) {
               $flags += '--' + $flag.Trim()
            }
            elseif (-not $filter) {
               $flags += '--' + $flag.Trim()
            }
         }
      }

      $flags | Sort-Object
   }
}