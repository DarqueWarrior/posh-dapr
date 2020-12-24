$script:daprCommands = @()

function DaprTabExpansion {
   param(
      [string] $lastBlock
   )

   process {
      switch -regex ($lastBlock) {

         # handles dapr <cmd> -<option> value -<option> ...
         'dapr(\.exe)* (?<cmd>\S+) ((-{1,2})(\S+) \S+ )*(-{1,2})(?<filter>\S*)$' {
            findDaprFlags -currentLine $matches[0] -cmd $matches['cmd'] -filter $matches['filter']
            break
         }

         # handles dapr stop <dapr instance>
         # handles dapr stop -a <dapr instance>
         # handles dapr stop -app-id <dapr instance>
         'dapr(\.exe)* stop (-a |--app-id )*(?<filter>\S*)$' {
            findDaprInstances -filter $matches['filter']
            break
         }

         # handles dapr <cmd>
         # handles dapr help <cmd>
         'dapr(\.exe)* (help )?(?<filter>\S*)$' {
            findDaprCommands -filter $matches['filter']
            break
         }
      }
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
         # The id is followed by the http port
         if ($i -match '(?<instance>[^ ]+) +[0-9]') {
            $instance = $matches['instance']

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

# By default the dapr command list is populated the first time daprCommands is invoked.
# Invoke PopulateDaprCommands in your profile if you don't want the initial hit.
function PopulateDaprCommands {
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

# Wrapped calls to dapr so they can be mocked in unit tests
function _callDapr {
   param(
      [string] $cmd,

      [switch] $getHelp
   )

   process {
      if ($getHelp.IsPresent) {
         return dapr help $cmd
      }
      else {
         return dapr $cmd
      }
   }
}

function findDaprFlags {
   param(
      # Contains all the text on the current line. This is used to remove
      # and flags that have already been used in ths command
      [string] $currentLine,

      [string] $cmd,

      [string] $filter
   )

   process {
      $optList = @()
      $output = _callDapr -cmd $cmd -getHelp

      foreach ($line in $output) {
         if ($line -match '^ +(-[a-zA-Z], )*--(?<flag>\S+)') {
            $opt = $matches['flag']

            # Skip if it is already on the current line
            if ($null -ne $(Select-String -InputObject $currentLine -Pattern $opt)) {
               continue
            }

            if ($filter -and $opt.StartsWith($filter)) {
               $optList += '--' + $opt.Trim()
            }
            elseif (-not $filter) {
               $optList += '--' + $opt.Trim()
            }
         }
      }

      $optList | Sort-Object
   }
}

$PowerTab_RegisterTabExpansion = if (Get-Module -Name powertab) {
   Get-Command Register-TabExpansion -Module powertab -ErrorAction SilentlyContinue
}

if ($PowerTab_RegisterTabExpansion) {
   & $PowerTab_RegisterTabExpansion "dapr.exe" -Type Command {
      param($Context, [ref]$TabExpansionHasOutput, [ref]$QuoteSpaces)  # 1:

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