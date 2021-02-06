Register-Completer dapr @(
	COMPGEN 'completion' ManagementCommand 'Generates shell completion scripts'
	COMPGEN 'components' ManagementCommand 'List all Dapr components. Supported platforms: Kubernetes'
	COMPGEN 'configurations' ManagementCommand 'List all Dapr configurations. Supported platforms: Kubernetes'
	COMPGEN 'dashboard' ManagementCommand 'Start Dapr dashboard. Supported platforms: Kubernetes and self-hosted'
	COMPGEN 'help' ManagementCommand 'Help about any command'
	COMPGEN 'init' ManagementCommand 'Install Dapr on supported hosting platforms. Supported platforms: Kubernetes and self-hosted'
	COMPGEN 'invoke' ManagementCommand 'Invoke a method on a given Dapr application. Supported platforms: Self-hosted'
	COMPGEN 'list' ManagementCommand 'List all Dapr instances. Supported platforms: Kubernetes and self-hosted'
	COMPGEN 'logs' ManagementCommand 'Get Dapr sidecar logs for an application. Supported platforms: Kubernetes'
	COMPGEN 'mtls' ManagementCommand 'Check if mTLS is enabled. Supported platforms: Kubernetes'
	COMPGEN 'publish' ManagementCommand 'Publish a pub-sub event. Supported platforms: Self-hosted'
	COMPGEN 'run' ManagementCommand 'Run Dapr and (optionally) your application side by side. Supported platforms: Self-hosted'
	COMPGEN 'status' ManagementCommand 'Show the health status of Dapr services. Supported platforms: Kubernetes'
	COMPGEN 'stop' ManagementCommand 'Stop Dapr instances and their associated apps. . Supported platforms: Self-hosted'
	COMPGEN 'uninstall' ManagementCommand 'Uninstall Dapr runtime. Supported platforms: Kubernetes and self-hosted'
	COMPGEN 'upgrade' ManagementCommand 'Upgrades a Dapr control plane installation in a cluster. Supported platforms: Kubernetes'
)
Register-Completer dapr -Option @(
	COMPGEN '-h' Switch 'help for dapr'
	COMPGEN '--help' Switch 'help for dapr'
	COMPGEN '-v' Switch 'version for dapr'
	COMPGEN '--version' Switch 'version for dapr'
)
Register-Completer dapr_completion @(
	COMPGEN 'bash' SubCommand 'Generates bash completion scripts'
	COMPGEN 'powershell' SubCommand 'Generates powershell completion scripts'
	COMPGEN 'zsh' SubCommand 'Generates zsh completion scripts'
)
Register-Completer dapr_completion -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
)
Register-Completer dapr_completion_bash -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
)
Register-Completer dapr_completion_powershell -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
)
Register-Completer dapr_completion_zsh -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
)
Register-Completer dapr_components -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'List all Dapr components in a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'List all Dapr components in a Kubernetes cluster'
)
Register-Completer dapr_configurations -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'List all Dapr configurations in a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'List all Dapr configurations in a Kubernetes cluster'
	COMPGEN '-n' string 'The configuration name to be printed (optional)'
	COMPGEN '--name' string 'The configuration name to be printed (optional)'
	COMPGEN '-o' string 'Output format (options: json or yaml or list) (default "list")'
	COMPGEN '--output' string 'Output format (options: json or yaml or list) (default "list")'
)
Register-Completer dapr_dashboard -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Opens Dapr dashboard in local browser via local proxy to Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Opens Dapr dashboard in local browser via local proxy to Kubernetes cluster'
	COMPGEN '-n' string 'The namespace where Dapr dashboard is running (default "dapr-system")'
	COMPGEN '--namespace' string 'The namespace where Dapr dashboard is running (default "dapr-system")'
	COMPGEN '-p' int 'The local port on which to serve Dapr dashboard (default 8080)'
	COMPGEN '--port' int 'The local port on which to serve Dapr dashboard (default 8080)'
	COMPGEN '-v' Switch 'Print the version for Dapr dashboard'
	COMPGEN '--version' Switch 'Print the version for Dapr dashboard'
)
Register-Completer dapr_help -Option @(
	COMPGEN '-h' Switch 'help for help'
	COMPGEN '--help' Switch 'help for help'
)
Register-Completer dapr_init -Option @(
	COMPGEN '--dashboard-version' string 'The version of the Dapr dashboard to install, for example: 1.0.0 (default "latest")'
	COMPGEN '--enable-ha' Switch 'Enable high availability (HA) mode'
	COMPGEN '--enable-mtls' Switch 'Enable mTLS in your cluster (default true)'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Deploy Dapr to a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Deploy Dapr to a Kubernetes cluster'
	COMPGEN '-n' string 'The Kubernetes namespace to install Dapr in (default "dapr-system")'
	COMPGEN '--namespace' string 'The Kubernetes namespace to install Dapr in (default "dapr-system")'
	COMPGEN '--network' string 'The Docker network on which to deploy the Dapr runtime'
	COMPGEN '--runtime-version' string 'The version of the Dapr runtime to install, for example: 1.0.0 (default "latest")'
	COMPGEN '--set' stringArray 'set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)'
	COMPGEN '-s' Switch 'Exclude placement service, Redis and Zipkin containers from self-hosted installation'
	COMPGEN '--slim' Switch 'Exclude placement service, Redis and Zipkin containers from self-hosted installation'
)
Register-Completer dapr_invoke -Option @(
	COMPGEN '-a' string 'The application id to invoke'
	COMPGEN '--app-id' string 'The application id to invoke'
	COMPGEN '-d' string 'The JSON serialized data string (optional)'
	COMPGEN '--data' string 'The JSON serialized data string (optional)'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-m' string 'The method to invoke'
	COMPGEN '--method' string 'The method to invoke'
	COMPGEN '-v' string 'The HTTP verb to use (default "POST")'
	COMPGEN '--verb' string 'The HTTP verb to use (default "POST")'
)
Register-Completer dapr_list -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'List all Dapr pods in a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'List all Dapr pods in a Kubernetes cluster'
)
Register-Completer dapr_logs -Option @(
	COMPGEN '-a' string 'The application id for which logs are needed'
	COMPGEN '--app-id' string 'The application id for which logs are needed'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Get logs from a Kubernetes cluster (default true)'
	COMPGEN '--kubernetes' Switch 'Get logs from a Kubernetes cluster (default true)'
	COMPGEN '-n' string 'The Kubernetes namespace in which your application is deployed (default "default")'
	COMPGEN '--namespace' string 'The Kubernetes namespace in which your application is deployed (default "default")'
	COMPGEN '-p' string 'The name of the pod in Kubernetes, in case your application has multiple pods (optional)'
	COMPGEN '--pod-name' string 'The name of the pod in Kubernetes, in case your application has multiple pods (optional)'
)
Register-Completer dapr_mtls @(
	COMPGEN 'expiry' SubCommand 'Checks the expiry of the root certificate'
	COMPGEN 'export' SubCommand 'Export the root CA, issuer cert and key from Kubernetes to local files'
)
Register-Completer dapr_mtls -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Check if mTLS is enabled in a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Check if mTLS is enabled in a Kubernetes cluster'
)
Register-Completer dapr_mtls_expiry -Option @(
	COMPGEN '-h' Switch 'help for expiry'
	COMPGEN '--help' Switch 'help for expiry'
)
Register-Completer dapr_mtls_export -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-o' string 'The output directory path to save the certs (default ".")'
	COMPGEN '--out' string 'The output directory path to save the certs (default ".")'
)
Register-Completer dapr_publish -Option @(
	COMPGEN '-d' string 'The JSON serialized data string (optional)'
	COMPGEN '--data' string 'The JSON serialized data string (optional)'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-i' string 'The ID of the publishing app'
	COMPGEN '--publish-app-id' string 'The ID of the publishing app'
	COMPGEN '-p' string 'The name of the pub/sub component'
	COMPGEN '--pubsub' string 'The name of the pub/sub component'
	COMPGEN '-t' string 'The topic to be published to'
	COMPGEN '--topic' string 'The topic to be published to'
)
Register-Completer dapr_run -Option @(
	COMPGEN '-a' string 'The id for your application, used for service discovery'
	COMPGEN '--app-id' string 'The id for your application, used for service discovery'
	COMPGEN '--app-max-concurrency' int 'The concurrency level of the application, otherwise is unlimited (default -1)'
	COMPGEN '-p' int 'The port your application is listening on (default -1)'
	COMPGEN '--app-port' int 'The port your application is listening on (default -1)'
	COMPGEN '-P' string 'The protocol (gRPC or HTTP) Dapr uses to talk to the application (default "http")'
	COMPGEN '--app-protocol' string 'The protocol (gRPC or HTTP) Dapr uses to talk to the application (default "http")'
	COMPGEN '--app-ssl' Switch 'Enable https when Dapr invokes the application'
	COMPGEN '-d' string 'The path for components directory (default "$HOMEPATH\\.dapr\\components")'
	COMPGEN '--components-path' string 'The path for components directory (default "$HOMEPATH\\.dapr\\components")'
	COMPGEN '-c' string 'Dapr configuration file (default "$HOMEPATH\\.dapr\\config.yaml")'
	COMPGEN '--config' string 'Dapr configuration file (default "$HOMEPATH\\.dapr\\config.yaml")'
	COMPGEN '-G' int 'The gRPC port for Dapr to listen on (default -1)'
	COMPGEN '--dapr-grpc-port' int 'The gRPC port for Dapr to listen on (default -1)'
	COMPGEN '-H' int 'The HTTP port for Dapr to listen on (default -1)'
	COMPGEN '--dapr-http-port' int 'The HTTP port for Dapr to listen on (default -1)'
	COMPGEN '--enable-profiling' Switch 'Enable pprof profiling via an HTTP endpoint'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '--log-level' string 'The log verbosity. Valid values are: debug, info, warn, error, fatal, or panic (default "info")'
	COMPGEN '-M' int 'The port of metrics on dapr (default -1)'
	COMPGEN '--metrics-port' int 'The port of metrics on dapr (default -1)'
	COMPGEN '--placement-host-address' string 'The host on which the placement service resides (default "localhost")'
	COMPGEN '--profile-port' int 'The port for the profile server to listen on (default -1)'
)
Register-Completer dapr_status -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Show the health status of Dapr services on Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Show the health status of Dapr services on Kubernetes cluster'
)
Register-Completer dapr_stop -Option @(
	COMPGEN '-a' string 'The application id to be stopped'
	COMPGEN '--app-id' string 'The application id to be stopped'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
)
Register-Completer dapr_uninstall -Option @(
	COMPGEN '--all' Switch 'Remove .dapr directory, Redis, Placement and Zipkin containers'
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Uninstall Dapr from a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Uninstall Dapr from a Kubernetes cluster'
	COMPGEN '-n' string 'The Kubernetes namespace to uninstall Dapr from (default "dapr-system")'
	COMPGEN '--namespace' string 'The Kubernetes namespace to uninstall Dapr from (default "dapr-system")'
	COMPGEN '--network' string 'The Docker network from which to remove the Dapr runtime'
)
Register-Completer dapr_upgrade -Option @(
	COMPGEN '-h' Switch 'Print this help message'
	COMPGEN '--help' Switch 'Print this help message'
	COMPGEN '-k' Switch 'Upgrade Dapr in a Kubernetes cluster'
	COMPGEN '--kubernetes' Switch 'Upgrade Dapr in a Kubernetes cluster'
	COMPGEN '--runtime-version' string 'The version of the Dapr runtime to upgrade to, for example: 1.0.0'
	COMPGEN '--set' stringArray 'set values on the command line (can specify multiple or separate values with commas: key1=val1,key2=val2)'
)
