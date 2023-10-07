{ lib
, stdenv
, python3
, fetchPypi
, fetchFromGitHub
, installShellFiles
}:

let
  version = "2.53.0";

  src = fetchFromGitHub {
    name = "azure-cli-${version}-src";
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-${version}";
    hash = "sha256-5c2Z0EJnKyLqWiz8/BEFAdy5A0+sBbai7UQ2KPL1jr8=";
  };

  # put packages that needs to be overridden in the py package scope
  py = import ./python-packages.nix {
    inherit stdenv src version python3 fetchPypi;
  };
in

py.pkgs.toPythonApplication (py.pkgs.buildAzureCliPackage {
  pname = "azure-cli";
  inherit version src;

  sourceRoot = "${src.name}/src/azure-cli";

  prePatch = ''
    substituteInPlace setup.py \
      --replace "chardet~=3.0.4" "chardet" \
      --replace "javaproperties~=0.5.1" "javaproperties" \
      --replace "scp~=0.13.2" "scp" \
      --replace "fabric~=2.4" "fabric"

    # remove namespace hacks
    # remove urllib3 because it was added as 'urllib3[secure]', which doesn't get handled well
    sed -i setup.py \
      -e '/urllib3/d'
  '';

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = with py.pkgs; [
    azure-appconfiguration
    azure-batch
    azure-cli-core
    azure-cli-telemetry
    azure-cosmos
    azure-data-tables
    azure-datalake-store
    azure-functions-devops-build
    azure-graphrbac
    azure-identity
    azure-keyvault
    azure-keyvault-administration
    azure-keyvault-keys
    azure-keyvault-certificates
    azure-keyvault-secrets
    azure-loganalytics
    azure-mgmt-advisor
    azure-mgmt-apimanagement
    azure-mgmt-applicationinsights
    azure-mgmt-appconfiguration
    azure-mgmt-appcontainers
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
    azure-storage-common
    azure-synapse-accesscontrol
    azure-synapse-artifacts
    azure-synapse-managedprivateendpoints
    azure-synapse-spark
    chardet
    colorama
    cryptography
    distro
    fabric
    jsmin
    knack
    mock
    paramiko
    pydocumentdb
    pygithub
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
    "azure.mgmt.appcontainers"
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
    downloadPage = "https://github.com/Azure/azure-cli/releases/tag/azure-cli-${version}";
    longDescription = ''
      The Azure Command-Line Interface (CLI) is a cross-platform
      command-line tool to connect to Azure and execute administrative
      commands on Azure resources. It allows the execution of commands
      through a terminal using interactive command-line prompts or a script.
    '';
    changelog = "https://github.com/MicrosoftDocs/azure-docs-cli/blob/main/docs-ref-conceptual/release-notes-azure-cli.md";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.mit;
    mainProgram = "az";
    maintainers = with maintainers; [ akechishiro jonringer ];
    platforms = platforms.all;
  };
})

