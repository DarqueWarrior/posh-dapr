Param(
   [string[]]$CustomScriptPath
)

function Select-CompletionResult {
   Param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      [NativeCommandCompletionResult[]]$CompletionResult,

      [switch]$OptionWithArg,

      [switch]$SubCommand,

      [switch]$ManagementCommand
   )

   Process {
      if ($OptionWithArg.IsPresent) {
         $CompletionResult = $CompletionResult | Where-Object { $_.CompletionText -Like '-*' -and $_.TextType -NE 'Switch' }
      }
      elseif ($SubCommand.IsPresent) {
         $CompletionResult = $CompletionResult | Where-Object TextType -EQ SubCommand
      }
      elseif ($ManagementCommand.IsPresent) {
         $CompletionResult = $CompletionResult | Where-Object TextType -EQ ManagementCommand
      }

      $CompletionResult
   }
}

function Invoke-CompletionCustomScript {
   Param(
      [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
      [string[]]$Path
   )

   Process {
      foreach ($p in $Path) {
         . $p
      }
   }
}

# The way you load files during development is different than in prod.
if (Test-Path $PSScriptRoot/posh-dapr.functions.ps1) {
   # Prod
   Invoke-CompletionCustomScript $PSScriptRoot/posh-dapr.functions.ps1
}
else {
   # Dev
   Invoke-CompletionCustomScript $PSScriptRoot/Private/completers.ps1, $PSScriptRoot/Private/completers4arguments.ps1
}

if ($CustomScriptPath) {
   Invoke-CompletionCustomScript $CustomScriptPath
}

$argumentCompleter = {
   Param([string]$wordToComplete, $commandAst, $cursorPosition)

   $counter = 1
   $subCommand = $null
   $completedFlags = @()
   $indexOfFirstArg = -1
   $optionWithArg = $null
   $completerName = 'dapr'
   $startsWithHyphen = $false
   $managementCommand = $null

   for (; $counter -lt $commandAst.CommandElements.Count; $counter++) {
      $ce = $commandAst.CommandElements[$counter]
      if ($cursorPosition -lt $ce.Extent.EndColumnNumber) {
         break
      }

      if ($optionWithArg) {
         # Keep track of all completed options so we don't return them
         # if the user is adding an option
         $completedFlags += $optionWithArg

         # The argument of $optionWithArg is completed by this $ce
         $optionWithArg = $null

         continue
      }

      $text = $ce.Extent.Text
      if ($text.StartsWith('-')) {
         if ($text -in (Invoke-Completer $completerName -Option -ArgumentList $wordToComplete, $commandAst, $cursorPosition |
               Select-CompletionResult -OptionWithArg).CompletionText) {
            $optionWithArg = $text
         }
      }
      elseif (!$managementCommand) {
         $managementCommand = $text
         $completerName += "_$managementCommand"
      }
      elseif ($managementCommand -and !$subCommand) {
         $results = Invoke-Completer $completerName -ArgumentList $wordToComplete, $commandAst, $cursorPosition
         if ($text -in ($results | Select-CompletionResult -SubCommand).CompletionText) {
            $subCommand = $text
            $completerName += "_$subCommand"
         }
         elseif ($text -in ($results | Select-CompletionResult -ManagementCommand).CompletionText) {
            $managementCommand = $text
            $completerName += "_$managementCommand"
         }
      }
      elseif ($indexOfFirstArg -lt 0) {
         $indexOfFirstArg = $counter
      }
   }

   if ($optionWithArg) {
      $completerName += "_$optionWithArg"
   }

   # At this point, $completerName is any of the following:
   # 'dapr'
   # 'dapr_optionWithArg'
   # 'dapr_managementCommand'
   # 'dapr_managementCommand_subCommand'
   # 'dapr_managementCommand_subCommand_optionWithArg'
   # These managementCommand can be followed by managementCommand (`trust` command)

   if ($wordToComplete) {
      $ceElements = $commandAst.CommandElements[$counter].Elements
      if ($ceElements) {
         # comma-separated args
         foreach ($cee in $ceElements) {
            if (($wordToComplete -eq $cee.Value) -and ($cursorPosition -ge $cee.Extent.StartOffset)) {
               $wordToCompleteSubstring = $wordToComplete.Substring(0, $cursorPosition - $cee.Extent.StartOffset)
            }
         }
         $wordToComplete = $wordToCompleteSubstring
      }
      else {
         $wordToCompleteSubstring = $wordToComplete.Substring(0, $cursorPosition - $commandAst.CommandElements[$counter].Extent.StartOffset)
      }
   }

   if ($wordToComplete.StartsWith('-')) {
      $startsWithHyphen = $true
      $completionResult = Invoke-Completer $completerName -Option -ArgumentList $wordToComplete, $commandAst, $cursorPosition

      if ($completedFlags) {
         # Remove completed flags
         # Don't need to return flags that have already been used.
         $completionResult = $completionResult | Where-Object { $completedFlags -notcontains $_.CompletionText }
      }
   }
   else {
      $startsWithHyphen = $false
      $completionResult = Invoke-Completer $completerName -ArgumentList $wordToComplete, $commandAst, $cursorPosition, $indexOfFirstArg
   }

   if ($startsWithHyphen) {
      # This will find double hyphen flags even when the user only uses 1 in
      # the search. For example on dapr init the user can type -r and get
      # --runtime-version returned.
      $completionResult | Where-Object CompletionText -Like "*$wordToCompleteSubstring*"
   }
   else {
      # This makes sure the command starts with the word to search instead of
      # having that portion of the word anywhere in the commands. For example
      # if the user types in dapr i we don't want to return completion and
      # other commands that have an i anywhere in them. We only want to return
      # init and invoke.
      $completionResult | Where-Object CompletionText -Like "$wordToCompleteSubstring*"
   }
}

Register-NativeCommandArgumentCompleter dapr $argumentCompleter
