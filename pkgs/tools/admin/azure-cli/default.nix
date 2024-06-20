{ lib
, callPackage
, callPackages
, stdenvNoCC
, fetchurl
, fetchFromGitHub
, installShellFiles
, python3

  # Whether to include patches that enable placing certain behavior-defining
  # configuration files in the Nix store.
, withImmutableConfig ? true

  # List of extensions/plugins to include.
, withExtensions ? [ ]

, azure-cli
}:

let
  version = "2.61.0";

  src = fetchFromGitHub {
    name = "azure-cli-${version}-src";
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-${version}";
    hash = "sha256-RmCZigDenbX8OoIZeY087ga2AP8yRckyG0qZnN9gg44=";
  };

  # put packages that needs to be overridden in the py package scope
  py = callPackage ./python-packages.nix { inherit src version; };

  # Builder for Azure CLI extensions. Extensions are Python wheels that
  # outside of nix would be fetched by the CLI itself from various sources.
  mkAzExtension =
    { pname
    , version
    , url
    , sha256
    , description
    , ...
    }@args: python3.pkgs.buildPythonPackage ({
      format = "wheel";
      src = fetchurl { inherit url sha256; };
      meta = {
        inherit description;
        inherit (azure-cli.meta) platforms maintainers;
        homepage = "https://github.com/Azure/azure-cli-extensions";
        changelog = "https://github.com/Azure/azure-cli-extensions/blob/main/src/${pname}/HISTORY.rst";
        license = lib.licenses.mit;
        sourceProvenance = [ lib.sourceTypes.fromSource ];
      } // args.meta or { };
    } // (removeAttrs args [ "url" "sha256" "description" "meta" ]));

  extensions =
    callPackages ./extensions-generated.nix { inherit mkAzExtension; }
    // callPackages ./extensions-manual.nix { inherit mkAzExtension; };

  extensionDir = stdenvNoCC.mkDerivation {
    name = "azure-cli-extensions";
    dontUnpack = true;
    installPhase =
      let
        namePaths = map (p: "${p.pname},${p}/${python3.sitePackages}") withExtensions;
      in
      ''
        for line in ${lib.concatStringsSep " " namePaths}; do
          name=$(echo $line | cut -d',' -f1)
          path=$(echo $line | cut -d',' -f2)
          mkdir -p $out/$name
          for f in $(ls $path); do
            ln -s $path/$f $out/$name/$f
          done
        done
      '';
  };
in

py.pkgs.toPythonApplication (py.pkgs.buildAzureCliPackage rec {
  pname = "azure-cli";
  inherit version src;

  sourceRoot = "${src.name}/src/azure-cli";

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = with py.pkgs; [
    antlr4-python3-runtime
    applicationinsights
    argcomplete
    asn1crypto
    azure-appconfiguration
    azure-batch
    azure-cli-core
    azure-cli-telemetry
    azure-common
    azure-core
    azure-cosmos
    azure-data-tables
    azure-datalake-store
    azure-graphrbac
    azure-keyvault-administration
    azure-keyvault-certificates
    azure-keyvault-keys
    azure-keyvault-secrets
    azure-loganalytics
    azure-mgmt-advisor
    azure-mgmt-apimanagement
    azure-mgmt-appconfiguration
    azure-mgmt-appcontainers
    azure-mgmt-applicationinsights
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
    azure-mgmt-core
    azure-mgmt-cosmosdb
    azure-mgmt-databoxedge
    azure-mgmt-datalake-nspkg
    azure-mgmt-datalake-store
    azure-mgmt-datamigration
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
    azure-mgmt-managementgroups
    azure-mgmt-managedservices
    azure-mgmt-maps
    azure-mgmt-marketplaceordering
    azure-mgmt-media
    azure-mgmt-monitor
    azure-mgmt-msi
    azure-mgmt-netapp
    azure-mgmt-policyinsights
    azure-mgmt-privatedns
    azure-mgmt-rdbms
    azure-mgmt-recoveryservices
    azure-mgmt-recoveryservicesbackup
    azure-mgmt-redhatopenshift
    azure-mgmt-redis
    azure-mgmt-relay
    azure-mgmt-resource
    azure-mgmt-search
    azure-mgmt-security
    azure-mgmt-servicebus
    azure-mgmt-servicefabric
    azure-mgmt-servicefabricmanagedclusters
    azure-mgmt-servicelinker
    azure-mgmt-sql
    azure-mgmt-signalr
    azure-mgmt-sqlvirtualmachine
    azure-mgmt-storage
    azure-mgmt-synapse
    azure-mgmt-trafficmanager
    azure-mgmt-web
    azure-multiapi-storage
    azure-nspkg
    azure-storage-common
    azure-storage-blob
    azure-synapse-accesscontrol
    azure-synapse-artifacts
    azure-synapse-managedprivateendpoints
    azure-synapse-spark
    bcrypt
    certifi
    cffi
    chardet
    colorama
    cryptography
    distro
    fabric
    humanfriendly
    idna
    invoke
    isodate
    javaproperties
    jinja2
    jmespath
    jsondiff
    knack
    markupsafe
    msal-extensions
    msal
    msrest
    msrestazure
    oauthlib
    packaging
    paramiko
    pbr
    pkginfo
    portalocker
    psutil
    pycomposefile
    pycparser
    pygithub
    pyjwt
    pynacl
    pyopenssl
    python-dateutil
    requests-oauthlib
    requests
    scp
    semver
    setuptools
    six
    sshtunnel
    tabulate
    urllib3
    wcwidth
    websocket-client
    xmltodict
  ] ++ lib.optionals (!withImmutableConfig) [
    # pip is required to install extensions locally, but it's not needed if
    # we're using the default immutable configuration.
    pip
  ] ++ lib.concatMap (extension: extension.propagatedBuildInputs) withExtensions;

  postInstall = ''
    substituteInPlace az.completion.sh \
      --replace register-python-argcomplete ${py.pkgs.argcomplete}/bin/register-python-argcomplete
    installShellCompletion --bash --name az.bash az.completion.sh
    installShellCompletion --zsh --name _az az.completion.sh
  '' + lib.optionalString withImmutableConfig ''
    export HOME=$TMPDIR
    $out/bin/az --version
    mkdir -p $out/etc/azure
    mv $TMPDIR/.azure/commandIndex.json $out/etc/azure/commandIndex.json
    mv $TMPDIR/.azure/versionCheck.json $out/etc/azure/versionCheck.json
  '' + ''
    # remove garbage
    rm $out/bin/az.bat
    rm $out/bin/az.completion.sh
  '';

  # wrap the executable so that the python packages are available
  # it's just a shebang script which calls `python -m azure.cli "$@"`
  postFixup = ''
    wrapProgram $out/bin/az \
  '' + lib.optionalString withImmutableConfig ''
    --set AZURE_IMMUTABLE_DIR $out/etc/azure \
  '' + lib.optionalString (withExtensions != [ ]) ''
    --set AZURE_EXTENSION_DIR ${extensionDir} \
  '' + ''
    --set PYTHONPATH "${python3.pkgs.makePythonPath propagatedBuildInputs}:$out/${python3.sitePackages}"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    export HOME=$TMPDIR

    $out/bin/az --version
    $out/bin/az self-test
  '';

  # ensure these namespaces are able to be accessed
  pythonImportsCheck = [
    "azure.batch"
    "azure.cli.core"
    "azure.cli.telemetry"
    "azure.cosmos"
    "azure.datalake.store"
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
    "azure.mgmt.datalake.store"
    "azure.mgmt.datamigration"
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
    "azure.mgmt.netapp"
    "azure.mgmt.policyinsights"
    "azure.mgmt.privatedns"
    "azure.mgmt.rdbms"
    "azure.mgmt.recoveryservices"
    "azure.mgmt.recoveryservicesbackup"
    "azure.mgmt.redis"
    "azure.mgmt.relay"
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

  passthru = {
    inherit extensions;
    withExtensions = extensions: azure-cli.override { withExtensions = extensions; };
  };

  meta = with lib; {
    homepage = "https://github.com/Azure/azure-cli";
    description = "Next generation multi-platform command line experience for Azure";
    downloadPage = "https://github.com/Azure/azure-cli/releases/tag/azure-cli-${version}";
    longDescription = ''
      The Azure Command-Line Interface (CLI) is a cross-platform
      command-line tool to connect to Azure and execute administrative
      commands on Azure resources. It allows the execution of commands
      through a terminal using interactive command-line prompts or a script.

      `azure-cli` has extension support. For example, to install the `aks-preview` extension, use

      ```nix
      environment.systemPackages = [
        (azure-cli.withExtensions [ azure-cli.extensions.aks-preview ])
      ];
      ```

      To make the `azure-cli` immutable and prevent clashes in case `azure-cli` is also installed via other package managers,
      some configuration files were moved into the derivation. This can be disabled by overriding `withImmutableConfig = false`
      when building `azure-cli`.
    '';
    changelog = "https://github.com/MicrosoftDocs/azure-docs-cli/blob/main/docs-ref-conceptual/release-notes-azure-cli.md";
    sourceProvenance = [ sourceTypes.fromSource ];
    license = licenses.mit;
    mainProgram = "az";
    maintainers = with maintainers; [ jonringer ];
    platforms = platforms.all;
  };
})
