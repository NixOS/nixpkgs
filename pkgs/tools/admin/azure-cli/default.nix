{ stdenv

, fetchFromGitHub
, buildPythonPackage
, buildPythonApplication
, isPy3k

, adal
, argcomplete
, colorama
, humanfriendly
, jmespath
, knack
, mock
, paramiko
, prompt_toolkit
, pygments
, pyjwt
, pyopenssl
, pytz
, pyyaml
, requests
, six
, tabulate_0_7_7
, urllib3
, whoosh
, xmltodict
, scp
, sshtunnel
, pydocumentdb

, applicationinsights
, azure-batch
, azure-batch-extensions
, azure-datalake-store
, azure-graphrbac
, azure-keyvault
, azure-mgmt-advisor
, azure-mgmt-authorization
, azure-mgmt-batch
, azure-mgmt-batchai
, azure-mgmt-billing
, azure-mgmt-cdn
, azure-mgmt-cognitiveservices
, azure-mgmt-compute
, azure-mgmt-consumption
, azure-mgmt-containerinstance
, azure-mgmt-containerregistry
, azure-mgmt-containerservice
, azure-mgmt-cosmosdb
, azure-mgmt-datalake-analytics
, azure-mgmt-datalake-store
, azure-mgmt-devtestlabs
, azure-mgmt-dns
, azure-mgmt-eventgrid
, azure-mgmt-iothub
, azure-mgmt-iothubprovisioningservices
, azure-mgmt-keyvault
, azure-mgmt-marketplaceordering
, azure-mgmt-monitor
, azure-mgmt-msi
, azure-mgmt-network
, azure-mgmt-rdbms
, azure-mgmt-recoveryservices
, azure-mgmt-recoveryservicesbackup
, azure-mgmt-redis
, azure-mgmt-reservations
, azure-mgmt-resource
, azure-mgmt-servicefabric
, azure-mgmt-sql
, azure-mgmt-storage
, azure-mgmt-trafficmanager
, azure-mgmt-web
, azure-multiapi-storage
, azure-nspkg
, msrest
, msrestazure
, vsts-cd-manager

}:

let
  azureCliSrc = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-cli";
    rev = "azure-cli-2.0.27";
    sha256 = "10b6scbn74gqpglyzq20a40y9g6sz96zdffjb1np3js8l2z9frp8";
  };

  azure-cli-nspkg = buildPythonPackage rec {
    pname = "azure-cli-nspkg";
    version = "3.0.1";
    src = "${azureCliSrc}/src/azure-cli-nspkg";
    propagatedBuildInputs = [azure-nspkg];
    postFixup = ''
      rm $out/lib/python3.6/site-packages/azure/cli/__init__.py
    '';
  };

  azure-cli-command-modules-nspkg = buildPythonPackage rec {
    pname = "azure-cli-command-modules--nspkg";
    version = "0.1.17";
    src = "${azureCliSrc}/src/azure-cli-command_modules-nspkg";
    propagatedBuildInputs = [azure-cli-nspkg];
    postFixup = ''
      rm $out/lib/python3.6/site-packages/azure/cli/command_modules/__init__.py
    '';
  };

  azure-cli-core = buildPythonPackage rec {
    pname = "azure-cli-core";
    version = "2.0.27";
    src = "${azureCliSrc}/src/azure-cli-core";
    propagatedBuildInputs = [
      msrestazure
      msrest
      pygments
      six
      requests
      pyyaml
      pyopenssl
      paramiko
      jmespath
      knack
      humanfriendly
      colorama
      tabulate_0_7_7
      azure-cli-nspkg
      argcomplete
      applicationinsights
      adal
      pyjwt
    ];
    doCheck = false;
  };

  azure-cli-iot = buildPythonPackage rec {
    pname = "azure-cli-iot";
    version = "0.1.17";
    src = "${azureCliSrc}/src/command_modules/azure-cli-iot";
    propagatedBuildInputs = [
      azure-mgmt-iothubprovisioningservices
      azure-mgmt-iothub
      azure-cli-command-modules-nspkg
      azure-cli-core
      pyopenssl
    ];
    doCheck = false;
  };

  azure-cli-profile = buildPythonPackage rec {
    pname = "azure-cli-profile";
    version = "2.0.19";
    src = "${azureCliSrc}/src/command_modules/azure-cli-profile";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      adal
    ];
    doCheck = false;
  };

  azure-cli-find = buildPythonPackage rec {
    pname = "azure-cli-find";
    version = "0.2.8";
    src = "${azureCliSrc}/src/command_modules/azure-cli-find";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      whoosh
    ];
    doCheck = false;
  };

  azure-cli-interactive = buildPythonPackage rec {
    pname = "azure-cli-interactive";
    version = "0.3.16";
    src = "${azureCliSrc}/src/command_modules/azure-cli-interactive";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      applicationinsights
      six
      pyyaml
      jmespath
      prompt_toolkit
    ];
    doCheck = false;
  };

  azure-cli-extension = buildPythonPackage rec {
    pname = "azure-cli-extension";
    version = "0.0.9";
    src = "${azureCliSrc}/src/command_modules/azure-cli-extension";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
    ];
    doCheck = false;
  };

  azure-cli-keyvault = buildPythonPackage rec {
    pname = "azure-cli-keyvault";
    version = "2.0.18";
    src = "${azureCliSrc}/src/command_modules/azure-cli-keyvault";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      pyopenssl
      azure-mgmt-keyvault
      azure-keyvault
    ];
    doCheck = false;
  };

  azure-cli-storage = buildPythonPackage rec {
    pname = "azure-cli-storage";
    version = "2.0.18";
    src = "${azureCliSrc}/src/command_modules/azure-cli-storage";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-batch-extensions
      azure-mgmt-storage
      azure-multiapi-storage
    ];
    doCheck = false;
  };

  azure-cli-feedback = buildPythonPackage rec {
    pname = "azure-cli-feedback";
    version = "2.1.0";
    src = "${azureCliSrc}/src/command_modules/azure-cli-feedback";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      applicationinsights
    ];
    doCheck = false;
  };

  azure-cli-redis = buildPythonPackage rec {
    pname = "azure-cli-redis";
    version = "0.2.11";
    src = "${azureCliSrc}/src/command_modules/azure-cli-redis";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-redis
    ];
    doCheck = false;
  };

  azure-cli-cdn = buildPythonPackage rec {
    pname = "azure-cli-cdn";
    version = "0.0.13";
    src = "${azureCliSrc}/src/command_modules/azure-cli-cdn";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-cdn
    ];
    doCheck = false;
  };

  azure-cli-batch = buildPythonPackage rec {
    pname = "azure-cli-batch";
    version = "3.1.10";
    src = "${azureCliSrc}/src/command_modules/azure-cli-batch";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-keyvault
      azure-mgmt-batch
      azure-batch-extensions
      azure-batch
    ];
    doCheck = false;
  };

  azure-cli-configure = buildPythonPackage rec {
    pname = "azure-cli-configure";
    version = "2.0.14";
    src = "${azureCliSrc}/src/command_modules/azure-cli-configure";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
    ];
    doCheck = false;
  };

  azure-cli-dls = buildPythonPackage rec {
    pname = "azure-cli-dls";
    version = "0.0.19";
    src = "${azureCliSrc}/src/command_modules/azure-cli-dls";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-datalake-store
      azure-mgmt-datalake-store
    ];
    doCheck = false;
  };

  azure-cli-advisor = buildPythonPackage rec {
    pname = "azure-cli-advisor";
    version = "0.1.2";
    src = "${azureCliSrc}/src/command_modules/azure-cli-advisor";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-advisor
    ];
    doCheck = false;
  };

  azure-cli-resource = buildPythonPackage rec {
    pname = "azure-cli-resource";
    version = "2.0.23";
    src = "${azureCliSrc}/src/command_modules/azure-cli-resource";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-resource
      azure-mgmt-authorization
    ];
    doCheck = false;
  };

  azure-cli-network = buildPythonPackage rec {
    pname = "azure-cli-network";
    version = "2.0.23";
    src = "${azureCliSrc}/src/command_modules/azure-cli-network";
    buildInputs = [
      mock
    ];
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-resource
      azure-mgmt-network
      azure-mgmt-dns
      azure-mgmt-trafficmanager
    ];
    doCheck = false;
  };

  azure-cli-sql = buildPythonPackage rec {
    pname = "azure-cli-sql";
    version = "2.0.22";
    src = "${azureCliSrc}/src/command_modules/azure-cli-sql";
    buildInputs = [
      mock
    ];
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-storage
      azure-mgmt-sql
      six
    ];
    doCheck = false;
  };

  azure-cli-batchai = buildPythonPackage rec {
    pname = "azure-cli-batchai";
    version = "0.1.5";
    src = "${azureCliSrc}/src/command_modules/azure-cli-batchai";
    buildInputs = [
      mock
    ];
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-batchai
      adal
    ];
    doCheck = false;
  };

  azure-cli-monitor = buildPythonPackage rec {
    pname = "azure-cli-monitor";
    version = "0.1.2";
    src = "${azureCliSrc}/src/command_modules/azure-cli-monitor";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-resource
      azure-mgmt-monitor
    ];
    doCheck = false;
  };

  azure-cli-dla = buildPythonPackage rec {
    pname = "azure-cli-dla";
    version = "0.0.18";
    src = "${azureCliSrc}/src/command_modules/azure-cli-dla";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-resource
      azure-mgmt-datalake-store
      azure-mgmt-datalake-analytics
    ];
    doCheck = false;
  };

  azure-cli-container = buildPythonPackage rec {
    pname = "azure-cli-container";
    version = "0.0.18";
    src = "${azureCliSrc}/src/command_modules/azure-cli-container";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      pyyaml
      colorama
      azure-mgmt-containerinstance
    ];
    doCheck = false;
  };

  azure-cli-servicefabric = buildPythonPackage rec {
    pname = "azure-cli-servicefabric";
    version = "0.0.10";
    src = "${azureCliSrc}/src/command_modules/azure-cli-servicefabric";
    propagatedBuildInputs = [
      pyopenssl
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-keyvault
      azure-mgmt-servicefabric
    ];
    doCheck = false;
  };

  azure-cli-appservice = buildPythonPackage rec {
    pname = "azure-cli-appservice";
    version = "0.0.10";
    src = "${azureCliSrc}/src/command_modules/azure-cli-appservice";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      xmltodict
      urllib3
      vsts-cd-manager
      pyopenssl
      azure-mgmt-web
      azure-mgmt-containerregistry
    ];
    doCheck = false;
  };

  azure-cli-eventgrid = buildPythonPackage rec {
    pname = "azure-cli-eventgrid";
    version = "0.1.10";
    src = "${azureCliSrc}/src/command_modules/azure-cli-eventgrid";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-eventgrid
    ];
    doCheck = false;
  };

  azure-cli-acr = buildPythonPackage rec {
    pname = "azure-cli-acr";
    version = "2.0.21";
    src = "${azureCliSrc}/src/command_modules/azure-cli-acr";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-storage
      azure-mgmt-containerregistry
      azure-mgmt-resource
    ];
    doCheck = false;
  };

  azure-cli-backup = buildPythonPackage rec {
    pname = "azure-cli-backup";
    version = "1.0.6";
    src = "${azureCliSrc}/src/command_modules/azure-cli-backup";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-recoveryservices
      azure-mgmt-recoveryservicesbackup
    ];
    doCheck = false;
  };

  azure-cli-cosmosdb = buildPythonPackage rec {
    pname = "azure-cli-cosmosdb";
    version = "0.1.19";
    src = "${azureCliSrc}/src/command_modules/azure-cli-cosmosdb";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-cosmosdb
      scp
      pydocumentdb
    ];
    doCheck = false;
  };

  azure-cli-acs = buildPythonPackage rec {
    pname = "azure-cli-acs";
    version = "2.0.27";
    src = "${azureCliSrc}/src/command_modules/azure-cli-acs";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      sshtunnel
      six
      scp
      pyyaml
      paramiko
      azure-mgmt-containerservice
      azure-mgmt-compute
      azure-mgmt-authorization
      azure-graphrbac
    ];
    doCheck = false;
  };

  azure-cli-role = buildPythonPackage rec {
    pname = "azure-cli-role";
    version = "2.0.270";
    src = "${azureCliSrc}/src/command_modules/azure-cli-role";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      pytz
      azure-mgmt-monitor
      azure-mgmt-authorization
      azure-keyvault
      azure-graphrbac
    ];
    doCheck = false;
  };

  azure-cli-rdbms = buildPythonPackage rec {
    pname = "azure-cli-rdbms";
    version = "0.0.12";
    src = "${azureCliSrc}/src/command_modules/azure-cli-rdbms";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      six
      azure-mgmt-rdbms
    ];
    doCheck = false;
  };

  azure-cli-consumption = buildPythonPackage rec {
    pname = "azure-cli-consumption";
    version = "0.2.2";
    src = "${azureCliSrc}/src/command_modules/azure-cli-consumption";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-consumption
    ];
    doCheck = false;
  };
  azure-cli-reservations = buildPythonPackage rec {
    pname = "azure-cli-reservations";
    version = "0.2.2";
    src = "${azureCliSrc}/src/command_modules/azure-cli-reservations";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-reservations
    ];
    doCheck = false;
  };

  azure-cli-billing = buildPythonPackage rec {
    pname = "azure-cli-billing";
    version = "0.1.7";
    src = "${azureCliSrc}/src/command_modules/azure-cli-billing";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-billing
    ];
    doCheck = false;
  };

  azure-cli-lab = buildPythonPackage rec {
    pname = "azure-cli-lab";
    version = "0.0.17";
    src = "${azureCliSrc}/src/command_modules/azure-cli-lab";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-devtestlabs
      azure-graphrbac
    ];
    doCheck = false;
  };

  azure-cli-cognitiveservices = buildPythonPackage rec {
    pname = "azure-cli-cognitiveservices";
    version = "0.1.11";
    src = "${azureCliSrc}/src/command_modules/azure-cli-cognitiveservices";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-mgmt-cognitiveservices
    ];
    doCheck = false;
  };

  azure-cli-vm = buildPythonPackage rec {
    pname = "azure-cli-vm";
    version = "2.0.27";
    src = "${azureCliSrc}/src/command_modules/azure-cli-vm";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
      azure-multiapi-storage
      azure-mgmt-resource
      azure-mgmt-network
      azure-mgmt-msi
      azure-mgmt-marketplaceordering
      azure-mgmt-keyvault
      azure-mgmt-compute
      azure-mgmt-authorization
      azure-keyvault
    ];
    doCheck = false;
  };

  azure-cli-cloud = buildPythonPackage rec {
    pname = "azure-cli-cloud";
    version = "2.0.12";
    src = "${azureCliSrc}/src/command_modules/azure-cli-cloud";
    propagatedBuildInputs = [
      azure-cli-command-modules-nspkg
      azure-cli-core
    ];
    doCheck = false;
  };

in buildPythonApplication rec {
  pname = "azure-cli";
  version = "2.0.27";

  src = "${azureCliSrc}/src/azure-cli";

  disabled = !isPy3k;

  propagatedBuildInputs = [
    argcomplete
    colorama
    humanfriendly
    jmespath
    paramiko
    pyyaml
    six
    azure-cli-nspkg
    azure-cli-iot
    azure-cli-profile
    azure-cli-find
    azure-cli-interactive
    azure-cli-extension
    azure-cli-keyvault
    azure-cli-storage
    azure-cli-feedback
    azure-cli-redis
    azure-cli-cdn
    azure-cli-batch
    azure-cli-configure
    azure-cli-dls
    azure-cli-advisor
    azure-cli-resource
    azure-cli-network
    azure-cli-sql
    azure-cli-batchai
    azure-cli-monitor
    azure-cli-dla
    azure-cli-container
    azure-cli-servicefabric
    azure-cli-appservice
    azure-cli-eventgrid
    azure-cli-acr
    azure-cli-backup
    azure-cli-cosmosdb
    azure-cli-acs
    azure-cli-role
    azure-cli-rdbms
    azure-cli-consumption
    azure-cli-reservations
    azure-cli-billing
    azure-cli-lab
    azure-cli-cognitiveservices
    azure-cli-vm
    azure-cli-cloud
  ];

  postFixup = ''
    rm $out/bin/az.bat

    mkdir -p $out/etc/bash_completion.d
    mv $out/bin/az.completion.sh $out/etc/bash_completion.d

    wrapProgram $out/bin/az --prefix PATH ':' $program_PATH --set PYTHONPATH "$program_PYTHONPATH"
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Command-line tools for Azure";
    homepage = https://docs.microsoft.com/en-us/cli/azure/overview;
    license = licenses.mit;
    maintainers = with maintainers; [ rubbish ];
  };
}
