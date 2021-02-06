@{

   # Script module or binary module file associated with this manifest.
   RootModule        = 'NativeCommandCompletion'

   # Version number of this module.
   ModuleVersion     = '0.1.0'

   # ID used to uniquely identify this module
   GUID              = '48b10b80-65b6-4404-968f-0d1c902facdf'

   # Author of this module
   Author            = 'Donovan Brown'

   # Company or vendor of this module
   CompanyName       = 'N/A'

   # Copyright statement for this module
   Copyright         = '(c) 2018 Donovan Brown. All rights reserved.'

   # Description of the functionality provided by this module
   Description       = 'Native command completion module.'

   # Minimum version of the Windows PowerShell engine required by this module
   PowerShellVersion = '5.0'

   # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
   FunctionsToExport = ('New-CompletionResult', 'Register-Completer', 'Get-Completer', 'Invoke-Completer', 'Register-NativeCommandArgumentCompleter')

   # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
   # CmdletsToExport   = @()

   # Variables to export from this module
   VariablesToExport = '*'

   # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
   AliasesToExport   = @('COMPGEN')

   # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
   PrivateData       = @{

      PSData = @{

         # Tags applied to this module. These help with module discovery in online galleries.
         Tags       = 'native', 'completion'

         # A URL to the license for this module.
         LicenseUri = 'https://github.com/matt9ucci/DaprCompletion/blob/master/LICENSE'

         # A URL to the main website for this project.
         ProjectUri = 'https://github.com/matt9ucci/DaprCompletion'

      } # End of PSData hashtable

   } # End of PrivateData hashtable

}
