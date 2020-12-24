Set-StrictMode -Version Latest

Describe "DaprTabExpansion" {
   BeforeAll {
      $baseFolder = "$PSScriptRoot/.."
      $sampleFiles = "$PSScriptRoot/SampleFiles"
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      . "$baseFolder/Src/$sut"

      Mock _callDapr { Get-Content "$sampleFiles\dapr_help.txt" } -ParameterFilter { $cmd -eq 'help' }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_list_two_instances.txt" -Raw } -ParameterFilter { $cmd -eq 'list' }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_run.txt" } -ParameterFilter { $cmd -eq 'run' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_stop.txt" } -ParameterFilter { $cmd -eq 'stop' -and $getHelp -eq $true }

      $expectedCmds = @('completion', 'components', 'configurations', 'dashboard', 'help', 'init', 'invoke', 'list', 'logs', 'mtls', 'publish', 'run', 'status', 'stop', 'uninstall')
   }

   # Test that when dapr without the exe is used all the commands come back
   Context "dapr " {
      It 'Should expand options' {
         $actual = DaprTabExpansion("dapr ")

         $actual | Should -Be $expectedCmds
      }
   }

   # Test that when dapr with the exe is used all the commands come back
   Context "dapr.exe " {
      It 'Should expand options' {
         $actual = DaprTabExpansion("dapr.exe ")

         $actual | Should -Be $expectedCmds
      }
   }

   Context "dapr run -" {
      It 'Should expand options' {
         $expected = @('--app-id', '--app-max-concurrency', '--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--placement-host-address', '--profile-port')
         $actual = DaprTabExpansion("dapr run -")

         $actual | Should -Be $expected
      }
   }

   # Test that when a flag is passed it is expanded
   Context "dapr stop -a" {
      It 'Should expand options' {
         $actual = DaprTabExpansion("dapr stop -a")

         $actual | Should -Be '--app-id'
      }
   }

   # Test for stop the running instances are returned without a flag
   Context "dapr stop <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop ")

         $actual | Should -Be 'testing'
      }
   }

   # Test for stop the running instances are returned without a flag
   Context "dapr stop T" {
      It 'Should expand filtered instances' {
         $actual = DaprTabExpansion("dapr stop T")

         $actual | Should -Be 'testing'
      }
   }

   # Test for stop the running instances are returned with short flag
   Context "dapr stop -a <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop -a ")

         $actual | Should -Be 'testing'
      }
   }

   # Test for stop the running instances are returned with long flag
   Context "dapr stop --app-id <instance>" {
      It 'Should expand instances' {
         $actual = DaprTabExpansion("dapr stop --app-id ")

         $actual | Should -Be 'testing'
      }
   }

   # Test for run multiple flags can be expanded
   Context "dapr run --app-id test -" {
      It 'Should expand next flag' {
         $expected = $expected = @('--app-max-concurrency', '--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--placement-host-address', '--profile-port')
         $actual = DaprTabExpansion("dapr run --app-id test -")

         $actual | Should -Be $expected
      }
   }

   # Test for run multiple flags can be expanded
   Context "dapr run --app-id test --app-max-concurrency 10 -" {
      It 'Should expand next flag' {
         $expected = $expected = @('--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--placement-host-address', '--profile-port')
         $actual = DaprTabExpansion("dapr run --app-id test --app-max-concurrency 10 -")

         $actual | Should -Be $expected
      }
   }
}