Import-Module -Name $PSScriptRoot\..\Source\posh-dapr.psd1 -Force

Describe 'dapr' {
   BeforeAll {
      function Get-Result([string]$Text, [int]$CursorPosition = $Text.Length, [hashtable]$Options) {
         [System.Management.Automation.CommandCompletion]::CompleteInput($Text, $CursorPosition, $Options).CompletionMatches
      }
   }

   context 'dapr' {
      it 'Should return options starting with h' {
         $result = Get-Result 'dapr --h'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be '--help'
      }

      it 'Should return options starting with v' {
         $result = Get-Result 'dapr --v'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be '--version'
      }

      it 'Should return options starting with co' {
         $result = Get-Result 'dapr co'
         $result.Count | Should -Be 3
         $result[0].CompletionText | Should -Be 'completion'
         $result[1].CompletionText | Should -Be 'components'
         $result[2].CompletionText | Should -Be 'configurations'
      }
   }

   context 'dapr i' {
      it 'should return 2 options' {
         $result = Get-Result 'dapr i'
         $result.Count | Should -Be 2
         $result[0].CompletionText | Should -Be 'init'
         $result[1].CompletionText | Should -Be 'invoke'
      }
   }

   context 'dapr init --r' {
      it 'should return 1 option' {
         $result = Get-Result 'dapr init --r'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be '--runtime-version'
      }
   }

   context 'dapr init -r' {
      it 'should return 1 option' {
         $result = Get-Result 'dapr init -r'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be '--runtime-version'
      }
   }

   Context 'dapr mtls' {
      it 'should return 2 sub commands starting with e' {
         $result = Get-Result 'dapr mtls e'
         $result.Count | Should -Be 2
         $result[0].CompletionText | Should -Be 'expiry'
         $result[1].CompletionText | Should -Be 'export'
      }

      it 'should return 1 sub command starting with expo' {
         $result = Get-Result 'dapr mtls expo'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be 'export'
      }
   }

   Context 'dapr mtls -' {
      it 'should return 4 options' {
         $result = Get-Result 'dapr mtls -'
         $result.Count | Should -Be 4
         $i = 0
         $result[$i++].CompletionText | Should -Be '-h'
         $result[$i++].CompletionText | Should -Be '--help'
         $result[$i++].CompletionText | Should -Be '-k'
         $result[$i++].CompletionText | Should -Be '--kubernetes'
      }

      it 'should return 1 option starting with expo' {
         $result = Get-Result 'dapr mtls expo'
         $result.Count | Should -Be 1
         $result[0].CompletionText | Should -Be 'export'
      }
   }

   Context 'dapr mtls export ' {
      it 'should return 4 options' {
         $result = Get-Result 'dapr mtls export -'
         $result.Count | Should -Be 4
         $i = 0
         $result[$i++].CompletionText | Should -Be '-h'
         $result[$i++].CompletionText | Should -Be '--help'
         $result[$i++].CompletionText | Should -Be '-o'
         $result[$i++].CompletionText | Should -Be '--out'
      }
   }

   Context 'dapr stop -' {
      it 'should return 4 options' {
         $result = Get-Result 'dapr stop -'
         $result.Count | Should -Be 4
         $i = 0
         $result[$i++].CompletionText | Should -Be '-a'
         $result[$i++].CompletionText | Should -Be '--app-id'
         $result[$i++].CompletionText | Should -Be '-h'
         $result[$i++].CompletionText | Should -Be '--help'
      }
   }

   Context 'dapr stop -a test -' {
      it 'should return 3 options' {
         $result = Get-Result 'dapr stop -a test -'
         # -a should not be returned
         $result.Count | Should -Be 3
         $i = 0
         $result[$i++].CompletionText | Should -Be '--app-id'
         $result[$i++].CompletionText | Should -Be '-h'
         $result[$i++].CompletionText | Should -Be '--help'
      }
   }
}