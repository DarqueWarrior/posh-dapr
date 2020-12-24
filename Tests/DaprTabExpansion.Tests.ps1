Set-StrictMode -Version Latest

Describe "DaprTabExpansion" {
   BeforeAll {
      $baseFolder = "$PSScriptRoot/.."
      $sampleFiles = "$PSScriptRoot/SampleFiles"
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      . "$baseFolder/Src/$sut"

      Mock _getCmdHelp { Get-Content "$sampleFiles\dapr_help_stop.txt" }
      Mock _callDapr { Get-Content -Path "$sampleFiles\dapr_help.txt" } -ParameterFilter { $cmd -eq 'help' }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_list_two_instances.txt" -Raw } -ParameterFilter { $cmd -eq 'list' }
   }

   Context "dapr " {
      It 'Should expand options' {
         $expected = @('completion', 'components', 'configurations', 'dashboard', 'help', 'init', 'invoke', 'list', 'logs', 'mtls', 'publish', 'run', 'status', 'stop', 'uninstall')
         $actual = DaprTabExpansion("dapr ")

         $actual | Should -Be $expected
      }
   }

   Context "dapr.exe " {
      It 'Should expand options' {
         $expected = @('completion', 'components', 'configurations', 'dashboard', 'help', 'init', 'invoke', 'list', 'logs', 'mtls', 'publish', 'run', 'status', 'stop', 'uninstall')
         $actual = DaprTabExpansion("dapr.exe ")

         $actual | Should -Be $expected
      }
   }

   Context "dapr stop -a" {
      It 'Should expand options' {
         $actual = DaprTabExpansion("dapr stop -a")

         $actual | Should -Be '--app-id'
      }
   }

   Context "dapr stop <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop ")

         $actual | Should -Be 'testing'
      }
   }

   Context "dapr stop -a <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop -a ")

         $actual | Should -Be 'testing'
      }
   }

   Context "dapr stop --app-id <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop --app-id ")

         $actual | Should -Be 'testing'
      }
   }
}