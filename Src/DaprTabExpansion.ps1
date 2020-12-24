$script:daprCommands = @()

function DaprTabExpansion($lastBlock) {
   switch -regex ($lastBlock) {
      # handles dapr <cmd> -<option>
      # handles dapr <cmd> --<option>
      'dapr(\.exe)* (\S+) (-{1,2})(\S*)$' {
         daprOptions $matches[2] $matches[4];
         return;
      }

      # handles dapr <cmd>
      # handles dapr help <cmd>
      'dapr(\.exe)* (help )?(\S*)$' {
         daprCommands($matches[3]);
         return;
      }

      # handles dapr stop <dapr instance>
      'dapr(\.exe)* (stop) (-a|--app-id| )*(\S*)$' {
         daprInstances($matches[4])
         return;
      }
   }
}

function daprInstances($filter) {
   $output = _callDapr -cmd list
   $daprInstances = foreach ($i in $output) {
      # The id is followed by the http port
      if ($i -match '([^ ]+) +[0-9]') {
         $matches[1]
      }
   }

   $daprInstances
}

# By default the dapr command list is populated the first time daprCommands is invoked.
# Invoke PopulateDaprCommands in your profile if you don't want the initial hit.
function daprCommands($filter) {
   if ($script:daprCommands.Length -eq 0) {
      PopulateDaprCommands
   }

   if ($filter) {
      $daprCommands | Where-Object { $_.StartsWith($filter) } | ForEach-Object { $_.Trim() } | Sort-Object
   }
   else {
      $daprCommands | ForEach-Object { $_.Trim() } | Sort-Object
   }
}

# By default the dapr command list is populated the first time daprCommands is invoked.
# Invoke PopulateDaprCommands in your profile if you don't want the initial hit.
function PopulateDaprCommands() {
   $output = _callDapr -cmd help
   $daprCommands = foreach ($cmd in $output) {
      # Stop once we reach the "Enabled Extensions" section of help.
      # Not sure if there's a better way to do this...
      if ($cmd -eq "enabled extensions:") {
         break
      }

      if ($cmd -match '^  ([a-z]+) +[^[]') {
         $matches[1]
      }
   }

   $script:daprCommands = $daprCommands
}

# Wrapped calls to dapr so they can be mocked in unit tests
function _callDapr($cmd) {
   return dapr $cmd
}

function _getCmdHelp($cmd) {
   return dapr help $cmd
}

function daprOptions($cmd, $filter) {
   $optList = @()
   $output = _getCmdHelp($cmd)
   foreach ($line in $output) {
      if ($line -match '^  .+--(\S+)') {
         $opt = $matches[1]
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
function TabExpansion($line, $lastWord) {
   $lastBlock = [regex]::Split($line, '[|;]')[-1]

   switch -regex ($lastBlock) {
      "^$(Get-AliasPattern dapr) (.*)" { DaprTabExpansion $lastBlock }

      # Fall back on existing tab expansion
      default { if (Test-Path Function:\TabExpansionBackup) { TabExpansionBackup $line $lastWord } }
   }
}