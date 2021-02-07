Set-StrictMode -Version Latest

Describe "PopulateDaprCommands" {
   BeforeAll {
      $baseFolder = "$PSScriptRoot/../../.."
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      . "$baseFolder/Source/Private/commons.ps1"
      . "$baseFolder/Source/Public/PopulateDaprCommands.ps1"
      . "$baseFolder/Source/Public/$sut"

      mock Get-DaprAliasPattern { "(dapr|dapr.exe|dapr -|darp.exe -|dapr --|dapr.exe --)" }
      mock DaprTabExpansion
   }

   Context "TabExpansion dapr command" {
      It 'Should pass to DaprTabExpansion' {
         TabExpansion -Line "dapr -" -lastWord "-"

         Should -Invoke DaprTabExpansion -Exactly -Times 1 -Scope It
      }
   }

   Context "TabExpansion non dapr command" {
      It 'Should pass to DaprTabExpansion' {
         TabExpansion -Line "cd d" -lastWord "d"

         Should -Invoke DaprTabExpansion -Exactly -Times 0 -Scope It
      }
   }
}