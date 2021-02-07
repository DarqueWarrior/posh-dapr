$releasesAll = { Get-Releases }
$instancesAll = { Get-Instances }

Register-Completer dapr_stop_-a $instancesAll
Register-Completer dapr_stop_--app-id $instancesAll
Register-Completer dapr_instance_stop $instancesAll
Register-Completer dapr_init_--runtime-version $releasesAll

# You can omit the -a or --app-id and just provide the instance
Register-Completer dapr_stop (Get-Completer dapr_instance_stop)