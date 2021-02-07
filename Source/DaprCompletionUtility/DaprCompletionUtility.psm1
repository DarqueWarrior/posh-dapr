# Wrapped calls to dapr so they can be mocked in unit tests
function _callDapr {
   [CmdletBinding()]
   param(
      [string] $cmd,

      [string] $subCmd,

      [switch] $getHelp
   )

   process {
      if ($getHelp.IsPresent) {
         return dapr help $cmd $subCmd
      }
      else {
         return dapr $cmd
      }
   }
}

function Get-Releases {
   [CmdletBinding()]
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

function Get-Instances {
   [CmdletBinding()]
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