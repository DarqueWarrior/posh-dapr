class NativeCommandCompletionResult : System.Management.Automation.CompletionResult {
   [string]$TextType

   NativeCommandCompletionResult(
      [string]$CompletionText,
      [string]$ListItemText,
      [System.Management.Automation.CompletionResultType]$ResultType,
      [string]$ToolTip,
      [string]$TextType) :
   base($CompletionText, $ListItemText, $ResultType, $ToolTip) {

      $this.TextType = $TextType
   }
}

$nativeCommandCompleters = @{}

function New-CompletionResult {
   [CmdletBinding(SupportsShouldProcess = $true)]
   param (
      [Parameter(Mandatory)]
      [string]$CompletionText,
      [string]$TextType,
      [string]$ToolTip = $CompletionText,
      [string]$ListItemText = $CompletionText,
      [System.Management.Automation.CompletionResultType]$ResultType
   )

   if (!$ResultType) {
      if ($CompletionText.StartsWith('-')) {
         $ResultType = [System.Management.Automation.CompletionResultType]::ParameterName
      }
      elseif ($TextType -like '*Command') {
         $ResultType = [System.Management.Automation.CompletionResultType]::Command
      }
      else {
         $ResultType = [System.Management.Automation.CompletionResultType]::Text
      }
   }

   if ($Force -or $pscmdlet.ShouldProcess($CompletionText, "Add new completion result")) {
      New-Object NativeCommandCompletionResult $CompletionText, $ListItemText, $ResultType, $ToolTip, $TextType
   }
}

Set-Alias -Name COMPGEN -Value New-CompletionResult

function Register-Completer {
   param (
      [Parameter(Mandatory)]
      [string]$Name,
      $Completer,
      [Alias('Option')]
      $Parameter
   )

   if (!$nativeCommandCompleters.ContainsKey($Name)) {
      $nativeCommandCompleters[$Name] = @{}
   }

   if ($Completer) {
      $nativeCommandCompleters[$Name].completer = $Completer
   }

   if ($Parameter) {
      $nativeCommandCompleters[$Name].parameter = $Parameter
   }
}

function Get-Completer {
   param (
      [Parameter(Mandatory)]
      [string]$Name,
      [Alias('Option')]
      [switch]$Parameter
   )

   if ($Parameter) {
      $nativeCommandCompleters[$Name].parameter
   }
   else {
      $nativeCommandCompleters[$Name].completer
   }
}

function Invoke-Completer {
   param (
      [Parameter(Mandatory, Position = 0)]
      [string]$Name,

      [Alias('Option')]
      [switch]$Parameter,

      [Object[]]$ArgumentList
   )

   if ($Parameter.IsPresent) {
      $cmpltr = $nativeCommandCompleters[$Name].parameter
   }
   else {
      $cmpltr = $nativeCommandCompleters[$Name].completer
   }

   if ($cmpltr -is [scriptblock]) {
      $cmpltr = Invoke-Command -ScriptBlock $cmpltr -ArgumentList $ArgumentList
   }

   foreach ($c in $cmpltr) {
      if ($c -is [NativeCommandCompletionResult]) {
         $c
      }
      else {
         New-CompletionResult -CompletionText $c -TextType Text -ResultType ([System.Management.Automation.CompletionResultType]::Text) -Force
      }
   }
}

function Register-NativeCommandArgumentCompleter {
   param (
      [Parameter(Mandatory)]
      [string] $CommandName,

      [Parameter(Mandatory)]
      [scriptblock] $ScriptBlock
   )

   $script = $ScriptBlock
   $CommandName, (Get-Alias -Definition $CommandName -ErrorAction Ignore).Name | ForEach-Object {
      if ($_) {
         Register-ArgumentCompleter -CommandName $_ -ScriptBlock $script -Native
      }
   }
}