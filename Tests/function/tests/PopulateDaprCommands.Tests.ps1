Set-StrictMode -Version Latest

Describe "DaprTabExpansion" {
   BeforeAll {
      $baseFolder = "$PSScriptRoot/../../.."
      $sampleFiles = "$PSScriptRoot/../../SampleFiles"
      $sut = (Split-Path -Leaf $PSCommandPath).Replace(".Tests.", ".")
      . "$baseFolder/Source/Private/commons.ps1"
      . "$baseFolder/Source/Public/$sut"

      Mock _callDapr { Get-Content "$sampleFiles\dapr_help.txt" } -ParameterFilter { $cmd -eq 'help' }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_list_two_instances.txt" -Raw } -ParameterFilter { $cmd -eq 'list' }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_run.txt" } -ParameterFilter { $cmd -eq 'run' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_mtls.txt" } -ParameterFilter { $cmd -eq 'mtls' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_logs.txt" } -ParameterFilter { $cmd -eq 'logs' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_stop.txt" } -ParameterFilter { $cmd -eq 'stop' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_help.txt" } -ParameterFilter { $cmd -eq 'help' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_upgrade.txt" } -ParameterFilter { $cmd -eq 'upgrade' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_uninstall.txt" } -ParameterFilter { $cmd -eq 'uninstall' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_completion.txt" } -ParameterFilter { $cmd -eq 'completion' -and $getHelp -eq $true }
      Mock _callDapr { Get-Content "$sampleFiles\dapr_help_mtls_export.txt" } -ParameterFilter { $cmd -eq 'mtls' -and $subCmd -eq 'export' -and $getHelp -eq $true }

      Mock Invoke-RestMethod {
         $(Get-Content "$sampleFiles\dapr_init__runtime_version.json" -Raw | ConvertFrom-Json).value
      } -ParameterFilter { $Uri -eq 'https://api.github.com/repos/dapr/dapr/releases' }

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
         $expected = @('--app-id', '--app-max-concurrency', '--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--metrics-port', '--placement-host-address', '--profile-port')
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

   Context "dapr init --runtime-version <release>" {
      It 'Should expand runtime versions' {
         $actual = DaprTabExpansion("dapr init --runtime-version ")

         $actual.count | Should -Be 4
      }
   }

   Context "dapr init -k --runtime-version <release>" {
      It 'Should expand runtime versions' {
         $actual = DaprTabExpansion("dapr init -k --runtime-version ")

         $actual.count | Should -Be 4
      }
   }

   Context "dapr upgrade --runtime-version <release>" {
      It 'Should expand runtime versions' {
         $actual = DaprTabExpansion("dapr upgrade --runtime-version ")

         $actual.count | Should -Be 4
      }
   }

   Context "dapr upgrade --set key=value --s" {
      It 'Should allow mupliple sets' {
         $expected = @('--set')
         $actual = DaprTabExpansion("dapr upgrade --set key=value --s")

         $actual | Should -Be $expected
      }
   }

   Context "dapr uninstall -" {
      It 'Should expand next flag' {
         $expected = @('--all', '--help', '--kubernetes', '--namespace', '--network')
         $actual = DaprTabExpansion("dapr uninstall -")

         $actual | Should -Be $expected
      }
   }

   # Test for run multiple flags can be expanded
   Context "dapr run --app-id test -" {
      It 'Should expand next flag' {
         $expected = @('--app-max-concurrency', '--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--metrics-port', '--placement-host-address', '--profile-port')
         $actual = DaprTabExpansion("dapr run --app-id test -")

         $actual | Should -Be $expected
      }
   }

   # Test for run multiple flags can be expanded
   Context "dapr run --app-id test --app-max-concurrency 10 -" {
      It 'Should expand next flag' {
         $expected = @('--app-port', '--app-protocol', '--app-ssl', '--components-path', '--config', '--dapr-grpc-port', '--dapr-http-port', '--enable-profiling', '--help', '--log-level', '--metrics-port', '--placement-host-address', '--profile-port')
         $actual = DaprTabExpansion("dapr run --app-id test --app-max-concurrency 10 -")

         $actual | Should -Be $expected
      }
   }

   # Test for sub commands
   Context "dapr completion " {
      It 'Should expand sub commands' {
         $expected = @('bash', 'powershell', 'zsh')
         $actual = DaprTabExpansion("dapr completion ")

         $actual | Should -Be $expected
      }
   }

   # Test for help commands
   Context "dapr help " {
      It 'Should expand commands' {
         $actual = DaprTabExpansion("dapr help ")

         $actual | Should -Be $expectedCmds
      }
   }

   # Test for help of sub commands
   Context "dapr help mtls " {
      It 'Should expand commands' {
         $expected = @('expiry', 'export')
         $actual = DaprTabExpansion("dapr help mtls ")

         $actual | Should -Be $expected
      }
   }

   # Test for flags of sub commands
   Context "dapr mtls export -" {
      It 'Should expand flags' {
         $expected = ('--help', '--out')
         $actual = DaprTabExpansion("dapr mtls export -")

         $actual | Should -Be $expected
      }
   }
}