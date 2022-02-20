{ stdenv, lib, python3, fetchFromGitHub, installShellFiles }:

let
  version = "2.32.0";
  srcName = "azure-cli-${version}-src";

  src = fetchFromGitHub {
    name = srcName;
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-${version}";
    sha256 = "sha256-PXY32bfuK0bQGI0N+XHs9lakF6K7+WjrHMvuNgDFSJM=";
  };

  # put packages that needs to be overriden in the py package scope
  py = import ./python-packages.nix {
    inherit stdenv lib src version python3;
  };
in
py.pkgs.toPythonApplication (py.pkgs.buildAzureCliPackage {
  pname = "azure-cli";
  inherit version src;

  sourceRoot = "${srcName}/src/azure-cli";

  prePatch = ''
    substituteInPlace setup.py \
      --replace "chardet~=3.0.4" "chardet" \
      --replace "javaproperties~=0.5.1" "javaproperties" \
      --replace "pytz==2019.1" "pytz" \
      --replace "scp~=0.13.2" "scp" \
      --replace "PyNaCl~=1.4.0" "PyNaCl" \
      --replace "jsondiff~=1.2.0" "jsondiff~=1.2" \
      --replace "antlr4-python3-runtime~=4.7.2" "antlr4-python3-runtime~=4.7" \
      --replace "mock~=4.0" "mock"

    # remove namespace hacks
    # remove urllib3 because it was added as 'urllib3[secure]', which doesn't get handled well
    sed -i setup.py \
      -e '/azure-cli-command_modules-nspkg/d' \
      -e '/azure-cli-nspkg/d' \
      -e '/urllib3/d'
  '';

  nativeBuildInputs = [ installShellFiles ];

  propagatedBuildInputs = with py.pkgs; [
    azure-appconfiguration
    azure-batch
    azure-cli-core
    azure-cli-telemetry
    azure-cosmos
    azure-datalake-store
    azure-functions-devops-build
    azure-graphrbac
    azure-identity
    azure-keyvault
    azure-keyvault-administration
    azure-keyvault-keys
    azure-loganalytics
    azure-mgmt-advisor
    azure-mgmt-apimanagement
    azure-mgmt-applicationinsights
    azure-mgmt-appconfiguration
    azure-mgmt-authorization
    azure-mgmt-batch
    azure-mgmt-batchai
    azure-mgmt-billing
    azure-mgmt-botservice
    azure-mgmt-cdn
    azure-mgmt-cognitiveservices
    azure-mgmt-compute
    azure-mgmt-consumption
    azure-mgmt-containerinstance
    azure-mgmt-containerregistry
    azure-mgmt-containerservice
    azure-mgmt-cosmosdb
    azure-mgmt-databoxedge
    azure-mgmt-datalake-analytics
    azure-mgmt-datalake-store
    azure-mgmt-datamigration
    azure-mgmt-deploymentmanager
    azure-mgmt-devtestlabs
    azure-mgmt-dns
    azure-mgmt-eventgrid
    azure-mgmt-eventhub
    azure-mgmt-extendedlocation
    azure-mgmt-hdinsight
    azure-mgmt-imagebuilder
    azure-mgmt-iotcentral
    azure-mgmt-iothub
    azure-mgmt-iothubprovisioningservices
    azure-mgmt-keyvault
    azure-mgmt-kusto
    azure-mgmt-loganalytics
    azure-mgmt-managedservices
    azure-mgmt-managementgroups
    azure-mgmt-maps
    azure-mgmt-marketplaceordering
    azure-mgmt-media
    azure-mgmt-monitor
    azure-mgmt-msi
    azure-mgmt-network
    azure-mgmt-netapp
    azure-mgmt-policyinsights
    azure-mgmt-privatedns
    azure-mgmt-rdbms
    azure-mgmt-recoveryservices
    azure-mgmt-recoveryservicesbackup
    azure-mgmt-redhatopenshift
    azure-mgmt-redis
    azure-mgmt-relay
    azure-mgmt-reservations
    azure-mgmt-resource
    azure-mgmt-search
    azure-mgmt-security
    azure-mgmt-servicebus
    azure-mgmt-servicefabric
    azure-mgmt-servicefabricmanagedclusters
    azure-mgmt-servicelinker
    azure-mgmt-signalr
    azure-mgmt-sql
    azure-mgmt-sqlvirtualmachine
    azure-mgmt-storage
    azure-mgmt-synapse
    azure-mgmt-trafficmanager
    azure-mgmt-web
    azure-multiapi-storage
    azure-storage-blob
    azure-synapse-accesscontrol
    azure-synapse-artifacts
    azure-synapse-managedprivateendpoints
    azure-synapse-spark
    colorama
    cryptography
    distro
    Fabric
    jsmin
    knack
    mock
    paramiko
    pydocumentdb
    PyGithub
    pygments
    pynacl
    pyopenssl
    pytz
    pyyaml
    psutil
    requests
    scp
    semver
    six
    sshtunnel
    urllib3
    vsts-cd-manager
    websocket-client
    xmltodict
    javaproperties
    jsondiff
    # urllib3[secure]
    ipaddress
    # shell completion
    argcomplete
  ];

  postInstall = ''
    substituteInPlace az.completion.sh \
      --replace register-python-argcomplete ${py.pkgs.argcomplete}/bin/register-python-argcomplete
    installShellCompletion --bash --name az.bash az.completion.sh
    installShellCompletion --zsh --name _az az.completion.sh

    # remove garbage
    rm $out/bin/az.bat
    rm $out/bin/az.completion.sh
  '';

  # wrap the executable so that the python packages are available
  # it's just a shebang script which calls `python -m azure.cli "$@"`
  postFixup = ''
    wrapProgram $out/bin/az \
      --set PYTHONPATH $PYTHONPATH
  '';

  # almost the entire test suite requires an azure account setup and networking
  # ensure that the azure namespaces are setup correctly and that azure.cli can be accessed
  checkPhase = ''
    HOME=$TMPDIR $out/bin/az --help > /dev/null
  '';

  # ensure these namespaces are able to be accessed
  pythonImportsCheck = [
    "azure.batch"
    "azure.cli.core"
    "azure.cli.telemetry"
    "azure.cosmos"
    "azure.datalake.store"
    "azure_functions_devops_build"
    "azure.graphrbac"
    "azure.keyvault"
    "azure.loganalytics"
    "azure.mgmt.advisor"
    "azure.mgmt.apimanagement"
    "azure.mgmt.applicationinsights"
    "azure.mgmt.appconfiguration"
    "azure.mgmt.authorization"
    "azure.mgmt.batch"
    "azure.mgmt.batchai"
    "azure.mgmt.billing"
    "azure.mgmt.botservice"
    "azure.mgmt.cdn"
    "azure.mgmt.cognitiveservices"
    "azure.mgmt.compute"
    "azure.mgmt.consumption"
    "azure.mgmt.containerinstance"
    "azure.mgmt.containerregistry"
    "azure.mgmt.containerservice"
    "azure.mgmt.cosmosdb"
    "azure.mgmt.datalake.analytics"
    "azure.mgmt.datalake.store"
    "azure.mgmt.datamigration"
    "azure.mgmt.deploymentmanager"
    "azure.mgmt.devtestlabs"
    "azure.mgmt.dns"
    "azure.mgmt.eventgrid"
    "azure.mgmt.eventhub"
    "azure.mgmt.hdinsight"
    "azure.mgmt.imagebuilder"
    "azure.mgmt.iotcentral"
    "azure.mgmt.iothub"
    "azure.mgmt.iothubprovisioningservices"
    "azure.mgmt.keyvault"
    "azure.mgmt.kusto"
    "azure.mgmt.loganalytics"
    "azure.mgmt.managedservices"
    "azure.mgmt.managementgroups"
    "azure.mgmt.maps"
    "azure.mgmt.marketplaceordering"
    "azure.mgmt.media"
    "azure.mgmt.monitor"
    "azure.mgmt.msi"
    "azure.mgmt.network"
    "azure.mgmt.netapp"
    "azure.mgmt.policyinsights"
    "azure.mgmt.privatedns"
    "azure.mgmt.rdbms"
    "azure.mgmt.recoveryservices"
    "azure.mgmt.recoveryservicesbackup"
    "azure.mgmt.redis"
    "azure.mgmt.relay"
    "azure.mgmt.reservations"
    "azure.mgmt.resource"
    "azure.mgmt.search"
    "azure.mgmt.security"
    "azure.mgmt.servicebus"
    "azure.mgmt.servicefabric"
    "azure.mgmt.signalr"
    "azure.mgmt.sql"
    "azure.mgmt.sqlvirtualmachine"
    "azure.mgmt.storage"
    "azure.mgmt.trafficmanager"
    "azure.mgmt.web"
    "azure.storage.blob"
    "azure.storage.common"
  ];

  meta = with lib; {
    homepage = "https://github.com/Azure/azure-cli";
    description = "Next generation multi-platform command line experience for Azure";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
})

