# This file packages Azure CLI extensions that don't have any requirements.
# Extensions with requirements should be placed in another file, so this one
# can be re-generated during update.
#
# Attributes were generated using the query-extension-index.sh script:
#   ./query-extension-index.sh --requirements=false --download --nix --cli-version=<version>
{ mkAzExtension }:
{
  account = mkAzExtension rec {
    pname = "account";
    version = "0.2.5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/account-${version}-py3-none-any.whl";
    sha256 = "0b94df323acfc48ea3141904649106bb85695187dbf63aa3b8448ec12bc00c23";
    description = "Microsoft Azure Command-Line Tools SubscriptionClient Extension";
  };
  acrquery = mkAzExtension rec {
    pname = "acrquery";
    version = "1.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/acrquery-${version}-py3-none-any.whl";
    sha256 = "9094137a4d08f2ede7b662c99df0665f338aae7bcaf4976bed5d42df754571f1";
    description = "Microsoft Azure Command-Line Tools AcrQuery Extension";
  };
  acrtransfer = mkAzExtension rec {
    pname = "acrtransfer";
    version = "1.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/acrtransfer-${version}-py3-none-any.whl";
    sha256 = "668b94d0341b663a610212f318b899a53be60ae0eb59c47e162f5dabd3483551";
    description = "Microsoft Azure Command-Line Tools Acrtransfer Extension";
  };
  ad = mkAzExtension rec {
    pname = "ad";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/ad-${version}-py3-none-any.whl";
    sha256 = "61df234e10759e9916c1d447ab02b82637de10fd97c31a17252e1f5183853883";
    description = "Microsoft Azure Command-Line Tools DomainServicesResourceProvider Extension";
  };
  adp = mkAzExtension rec {
    pname = "adp";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/adp-${version}-py3-none-any.whl";
    sha256 = "fd64519832f4fd314431f87176507e10249b8d165537f81d05c9ea5185ae84ec";
    description = "Microsoft Azure Command-Line Tools Adp Extension";
  };
  aem = mkAzExtension rec {
    pname = "aem";
    version = "0.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/aem-${version}-py2.py3-none-any.whl";
    sha256 = "25aaf9006ab1d115d7c484cfda1c9ad0e3617af6d2140db87499aaea81b67ff8";
    description = "Manage Azure Enhanced Monitoring Extensions for SAP";
  };
  ai-examples = mkAzExtension rec {
    pname = "ai-examples";
    version = "0.2.5";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/ai_examples-${version}-py2.py3-none-any.whl";
    sha256 = "badbdf5fc2e0b4a85c4124d3fc92859b582adf8f30f5727440ce81942140099a";
    description = "Add AI powered examples to help content";
  };
  aks-preview = mkAzExtension rec {
    pname = "aks-preview";
    version = "1.0.0b5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/aks_preview-${version}-py2.py3-none-any.whl";
    sha256 = "75378ea07dea6fdadb115e41e8394003fd63282560648fa92d8f055f1e2536eb";
    description = "Provides a preview for upcoming AKS features";
  };
  akshybrid = mkAzExtension rec {
    pname = "akshybrid";
    version = "0.1.2";
    url = "https://hybridaksstorage.z13.web.core.windows.net/HybridAKS/CLI/akshybrid-${version}-py3-none-any.whl";
    sha256 = "9767cda444c421573bc220e01cd58a67c30a36175cedba68b0454a3c6e983a8e";
    description = "Microsoft Azure Command-Line Tools HybridContainerService Extension";
  };
  alb = mkAzExtension rec {
    pname = "alb";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/alb-${version}-py3-none-any.whl";
    sha256 = "b020cd8cd3da6299dc978499dae452768b7651c3ed8e05f2f0b321bd9b8354d4";
    description = "Microsoft Azure Command-Line Tools ALB Extension";
  };
  alertsmanagement = mkAzExtension rec {
    pname = "alertsmanagement";
    version = "0.2.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/alertsmanagement-${version}-py3-none-any.whl";
    sha256 = "b45a5752924ab1205ff5862f03a4a465eccb4dd8e79900023498d674aa68665b";
    description = "Microsoft Azure Command-Line Tools AlertsManagementClient Extension";
  };
  amg = mkAzExtension rec {
    pname = "amg";
    version = "1.2.9";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/amg-${version}-py3-none-any.whl";
    sha256 = "dbea8dd0e85dd2f30f30cb66f0dd7f9d0314a7ff9765a4d074622b75aeccad2f";
    description = "Microsoft Azure Command-Line Tools Azure Managed Grafana Extension";
  };
  amlfs = mkAzExtension rec {
    pname = "amlfs";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/amlfs-${version}-py3-none-any.whl";
    sha256 = "21b5a12943e727315288aa0ca1c49a25803a656b7f388c3c637596cfdf67bd1d";
    description = "Microsoft Azure Command-Line Tools Amlfs Extension";
  };
  apic-extension = mkAzExtension rec {
    pname = "apic-extension";
    version = "1.0.0b4";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/apic_extension-${version}-py3-none-any.whl";
    sha256 = "67294fd30190b66b339c8d550e58e1401117b313bea638fb0c126dec26249408";
    description = "Microsoft Azure Command-Line Tools ApicExtension Extension";
  };
  appservice-kube = mkAzExtension rec {
    pname = "appservice-kube";
    version = "0.1.9";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/appservice_kube-${version}-py2.py3-none-any.whl";
    sha256 = "9107762296c67ef4035256a9790b075040f263804116a3f9a6866227ff6019ed";
    description = "Microsoft Azure Command-Line Tools App Service on Kubernetes Extension";
  };
  authV2 = mkAzExtension rec {
    pname = "authV2";
    version = "0.1.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/authV2-${version}-py3-none-any.whl";
    sha256 = "eb05636f8c78e2f83b7f452fe56f5a9ae496d6909dc36924ae5f98a2fb5bce41";
    description = "Microsoft Azure Command-Line Tools Authv2 Extension";
  };
  automanage = mkAzExtension rec {
    pname = "automanage";
    version = "0.1.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/automanage-${version}-py3-none-any.whl";
    sha256 = "42341a6cfdacb3af0433b10b3e9bcb5226d4c7fb59730378408a957662266551";
    description = "Microsoft Azure Command-Line Tools Automanage Extension";
  };
  automation = mkAzExtension rec {
    pname = "automation";
    version = "0.2.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/automation-${version}-py3-none-any.whl";
    sha256 = "1337a8bf90739df646231533801cce9050bad641c627382468c86af5f2f99d89";
    description = "Microsoft Azure Command-Line Tools AutomationClient Extension";
  };
  azure-firewall = mkAzExtension rec {
    pname = "azure-firewall";
    version = "1.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/azure_firewall-${version}-py2.py3-none-any.whl";
    sha256 = "920023c55ae72d7e85baa43d81d96683be0e8348228b6f8e89e479fd4092c0f8";
    description = "Manage Azure Firewall resources";
  };
  azurelargeinstance = mkAzExtension rec {
    pname = "azurelargeinstance";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/azurelargeinstance-${version}-py3-none-any.whl";
    sha256 = "a6e38c623cf14a9528df9f28aa98d9642c1e73c0a815becdce842e3a2f0f49ac";
    description = "Microsoft Azure Command-Line Tools Azurelargeinstance Extension";
  };
  azurestackhci = mkAzExtension rec {
    pname = "azurestackhci";
    version = "0.2.9";
    url = "https://hybridaksstorage.z13.web.core.windows.net/SelfServiceVM/CLI/azurestackhci-${version}-py3-none-any.whl";
    sha256 = "2557b2fe3fa2f951a2794ba967555ba54c2e93eb75538152f21ab2fb568fef16";
    description = "Microsoft Azure Command-Line Tools AzureStackHCI Extension";
  };
  baremetal-infrastructure = mkAzExtension rec {
    pname = "baremetal-infrastructure";
    version = "2.0.1";
    url = "https://github.com/Azure/azure-baremetalinfrastructure-cli-extension/releases/download/${version}/baremetal_infrastructure-2.0.1-py2.py3-none-any.whl";
    sha256 = "ea127d64603c8a45774cdf9aa80c4c8b5839a42719971b296beb96105fe5ef2d";
    description = "Additional commands for working with BareMetal instances";
  };
  bastion = mkAzExtension rec {
    pname = "bastion";
    version = "0.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/bastion-${version}-py3-none-any.whl";
    sha256 = "c20d8e423acef3b6728c9abdfe90ad4a7020f2d122068983d7b59b9e3fef84c3";
    description = "Microsoft Azure Command-Line Tools Bastion Extension";
  };
  billing-benefits = mkAzExtension rec {
    pname = "billing-benefits";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/billing_benefits-${version}-py3-none-any.whl";
    sha256 = "f71250d1c26690cc0e175cd5c9bcd59e76c7b701bb3a47c8273e4cf8bcca878e";
    description = "Microsoft Azure Command-Line Tools BillingBenefits Extension";
  };
  blockchain = mkAzExtension rec {
    pname = "blockchain";
    version = "0.1.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/blockchain-${version}-py3-none-any.whl";
    sha256 = "95a4788ab10052f6c1b4122db6ab140705db528e5cb3db3358580d703a2a7204";
    description = "Microsoft Azure Command-Line Tools BlockchainManagementClient Extension";
  };
  blueprint = mkAzExtension rec {
    pname = "blueprint";
    version = "0.3.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/blueprint-${version}-py3-none-any.whl";
    sha256 = "58d3835446dd93e585b0f6b520a2db6551b8a927e35e25da4747d4cf8a4c009b";
    description = "Microsoft Azure Command-Line Tools Blueprint Extension";
  };
  change-analysis = mkAzExtension rec {
    pname = "change-analysis";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/change_analysis-${version}-py3-none-any.whl";
    sha256 = "49f1761a1b1ad29169af2ecd5793e10ddec797ebb2610e7c70e1b1ab2b75126a";
    description = "Microsoft Azure Command-Line Tools ChangeAnalysis Extension";
  };
  cli-translator = mkAzExtension rec {
    pname = "cli-translator";
    version = "0.3.0";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/cli_translator-${version}-py3-none-any.whl";
    sha256 = "9ea6162d37fc3390be4dce64cb05c5c588070104f3e92a701ab475473565a8a9";
    description = "Translate ARM template to executable Azure CLI scripts";
  };
  confidentialledger = mkAzExtension rec {
    pname = "confidentialledger";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/confidentialledger-${version}-py3-none-any.whl";
    sha256 = "3afbf49f10cdddd9675562364ce2275f6f70eb5318fa85b658d711b1e24dc94e";
    description = "Microsoft Azure Command-Line Tools ConfidentialLedger Extension";
  };
  confluent = mkAzExtension rec {
    pname = "confluent";
    version = "0.4.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/confluent-${version}-py3-none-any.whl";
    sha256 = "7b812940a77094bc916c745a61b7732966de4e7943a7541c0a402c0d912bc6af";
    description = "Microsoft Azure Command-Line Tools ConfluentManagementClient Extension";
  };
  connectedmachine = mkAzExtension rec {
    pname = "connectedmachine";
    version = "0.7.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/connectedmachine-${version}-py3-none-any.whl";
    sha256 = "792975ebf0260767481b2ffab0aa3154509c55a9ab60c7f987c3fdead726cd82";
    description = "Microsoft Azure Command-Line Tools ConnectedMachine Extension";
  };
  connectedvmware = mkAzExtension rec {
    pname = "connectedvmware";
    version = "0.2.4";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/connectedvmware-${version}-py2.py3-none-any.whl";
    sha256 = "8a96c790317dfee523d548c28a51191746ff3b45ede4fee56e804d195de437f6";
    description = "Microsoft Azure Command-Line Tools Connectedvmware Extension";
  };
  connection-monitor-preview = mkAzExtension rec {
    pname = "connection-monitor-preview";
    version = "0.1.0";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/connection_monitor_preview-${version}-py2.py3-none-any.whl";
    sha256 = "9a796d5187571990d27feb9efeedde38c194f13ea21cbf9ec06131196bfd821d";
    description = "Microsoft Azure Command-Line Connection Monitor V2 Extension";
  };
  cosmosdb-preview = mkAzExtension rec {
    pname = "cosmosdb-preview";
    version = "0.26.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/cosmosdb_preview-${version}-py2.py3-none-any.whl";
    sha256 = "c761a022fa8e849534d51bb51c6b6a7c01b541a5f018532f7fe312f74f689b06";
    description = "Microsoft Azure Command-Line Tools Cosmosdb-preview Extension";
  };
  costmanagement = mkAzExtension rec {
    pname = "costmanagement";
    version = "0.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/costmanagement-${version}-py3-none-any.whl";
    sha256 = "5661a2082ecca000b0c764dc92585e2aa601ccd5eeeb296397533cf4da814cf6";
    description = "Microsoft Azure Command-Line Tools CostManagementClient Extension";
  };
  csvmware = mkAzExtension rec {
    pname = "csvmware";
    version = "0.3.0";
    url = "https://github.com/Azure/az-csvmware-cli/releases/download/${version}/csvmware-0.3.0-py2.py3-none-any.whl";
    sha256 = "dfb9767f05ac13c762ea9dc4327169e63a5c11879123544b200edb9a2c9a8a42";
    description = "Manage Azure VMware Solution by CloudSimple";
  };
  custom-providers = mkAzExtension rec {
    pname = "custom-providers";
    version = "0.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/custom_providers-${version}-py2.py3-none-any.whl";
    sha256 = "a9938f09c86fa4575e3c887206908cac15920af528c537c0b998362a1c43daf7";
    description = "Microsoft Azure Command-Line Tools Custom Providers Extension";
  };
  customlocation = mkAzExtension rec {
    pname = "customlocation";
    version = "0.1.3";
    url = "https://arcplatformcliextprod.blob.core.windows.net/customlocation/customlocation-${version}-py2.py3-none-any.whl";
    sha256 = "5e36435b1a81de25e74e70c45c2ac9f98065138c35050f29210ae40c18484e28";
    description = "Microsoft Azure Command-Line Tools Customlocation Extension";
  };
  databox = mkAzExtension rec {
    pname = "databox";
    version = "1.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/databox-${version}-py3-none-any.whl";
    sha256 = "7b41a60521d7cf652d4cdca052fc9d2ec6371f3d7884ec0a74ba9a7d5001d7bb";
    description = "Microsoft Azure Command-Line Tools Databox Extension";
  };
  databricks = mkAzExtension rec {
    pname = "databricks";
    version = "0.10.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/databricks-${version}-py3-none-any.whl";
    sha256 = "7db0b97b497512671343c472fad2ca7a0987ac2cddc0ae0ceab227e3d017718f";
    description = "Microsoft Azure Command-Line Tools DatabricksClient Extension";
  };
  datadog = mkAzExtension rec {
    pname = "datadog";
    version = "0.1.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/datadog-${version}-py3-none-any.whl";
    sha256 = "9a38fd5d6d01646f299ee7b5f68e82ad708889c7d0bd72e0b6b6b13e5455e937";
    description = "Microsoft Azure Command-Line Tools MicrosoftDatadogClient Extension";
  };
  datafactory = mkAzExtension rec {
    pname = "datafactory";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/datafactory-${version}-py3-none-any.whl";
    sha256 = "30941f7e2c093f040c958db024367b750068a5181554b23f7403f4522375c41e";
    description = "Microsoft Azure Command-Line Tools DataFactoryManagementClient Extension";
  };
  datamigration = mkAzExtension rec {
    pname = "datamigration";
    version = "0.6.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/datamigration-${version}-py3-none-any.whl";
    sha256 = "4a07a5272762f8f53f9fe61b295a800e63c0ea2900a29a526df2eabbe732bca7";
    description = "Microsoft Azure Command-Line Tools DataMigrationManagementClient Extension";
  };
  dataprotection = mkAzExtension rec {
    pname = "dataprotection";
    version = "0.11.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/dataprotection-${version}-py3-none-any.whl";
    sha256 = "ce31a7bb0c939d6eb6d71971f89441abaee172a3ba5b74dae0ebe88e4a8f5300";
    description = "Microsoft Azure Command-Line Tools DataProtectionClient Extension";
  };
  datashare = mkAzExtension rec {
    pname = "datashare";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/datashare-${version}-py3-none-any.whl";
    sha256 = "f1a801bd0c38eb2ebf9c2fb4e0b43a98470ae7b40bbcd05eb2aa596d69579c9e";
    description = "Microsoft Azure Command-Line Tools DataShareManagementClient Extension";
  };
  deploy-to-azure = mkAzExtension rec {
    pname = "deploy-to-azure";
    version = "0.2.0";
    url = "https://github.com/Azure/deploy-to-azure-cli-extension/releases/download/20200318.1/deploy_to_azure-${version}-py2.py3-none-any.whl";
    sha256 = "f925080ee7abc3aef733d4c6313170bdedaa9569af1b95427383bc3c59e4ceb8";
    description = "Deploy to Azure using Github Actions";
  };
  desktopvirtualization = mkAzExtension rec {
    pname = "desktopvirtualization";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/desktopvirtualization-${version}-py3-none-any.whl";
    sha256 = "6de28d6be58dd65ad8f25a9fa084676c54684f00f9938f5db7d0392282783e04";
    description = "Microsoft Azure Command-Line Tools DesktopVirtualizationAPIClient Extension";
  };
  dev-spaces = mkAzExtension rec {
    pname = "dev-spaces";
    version = "1.0.6";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/dev_spaces-${version}-py2.py3-none-any.whl";
    sha256 = "71041808b27cd9d33fd905c5080c97f61291816f2dddd6dcdb2e66b9fb6ebf59";
    description = "Dev Spaces provides a rapid, iterative Kubernetes development experience for teams";
  };
  devcenter = mkAzExtension rec {
    pname = "devcenter";
    version = "5.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/devcenter-${version}-py3-none-any.whl";
    sha256 = "873ce4ec274710a361ba2a6bf93d8820949d955bf4386881d9a37ed87bb0d054";
    description = "Microsoft Azure Command-Line Tools DevCenter Extension";
  };
  diskpool = mkAzExtension rec {
    pname = "diskpool";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/diskpool-${version}-py3-none-any.whl";
    sha256 = "9ae6aaea85a17529da2a4e51c2ba2aba55b4b26816d5618eafd0f9fdc43b67b7";
    description = "Microsoft Azure Command-Line Tools StoragePoolManagement Extension";
  };
  dms-preview = mkAzExtension rec {
    pname = "dms-preview";
    version = "0.15.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/dms_preview-${version}-py2.py3-none-any.whl";
    sha256 = "556c145c03b8d529d8e77f7b35702fb8de382891635e858f928117f33688ee9c";
    description = "Support for new Database Migration Service scenarios";
  };
  dnc = mkAzExtension rec {
    pname = "dnc";
    version = "0.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/dnc-${version}-py3-none-any.whl";
    sha256 = "e38474ca9b28bed5dde388cf73dff9e3504825032b03c5bf8930c25caf292026";
    description = "Microsoft Azure Command-Line Tools Dnc Extension";
  };
  dns-resolver = mkAzExtension rec {
    pname = "dns-resolver";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/dns_resolver-${version}-py3-none-any.whl";
    sha256 = "1c4bb8216e509c2f08fa75c45930ec377768326f30cb9ab125842aa9352c6e2e";
    description = "Microsoft Azure Command-Line Tools DnsResolverManagementClient Extension";
  };
  dynatrace = mkAzExtension rec {
    pname = "dynatrace";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/dynatrace-${version}-py3-none-any.whl";
    sha256 = "112a7e423461d1b6f7c385fe8b73b4f2b850e2570c35a54a4bbcc2e87afec661";
    description = "Microsoft Azure Command-Line Tools Dynatrace Extension";
  };
  edgeorder = mkAzExtension rec {
    pname = "edgeorder";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/edgeorder-${version}-py3-none-any.whl";
    sha256 = "186a06d0f8603f7e0faeed5296ecc73bf1096e0d681acea42d5ebccc1670357b";
    description = "Microsoft Azure Command-Line Tools EdgeOrderManagementClient Extension";
  };
  elastic = mkAzExtension rec {
    pname = "elastic";
    version = "1.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/elastic-${version}-py3-none-any.whl";
    sha256 = "1d99dbcc10b99185b4cd9b64a8835d80b424226e5cf5d40b3e3ae1d435532657";
    description = "Microsoft Azure Command-Line Tools MicrosoftElastic Extension";
  };
  elastic-san = mkAzExtension rec {
    pname = "elastic-san";
    version = "1.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/elastic_san-${version}-py3-none-any.whl";
    sha256 = "6d2f1247ae78e431d4834989df581cd21241d16b97071bf672fb8b71ee3ad702";
    description = "Microsoft Azure Command-Line Tools ElasticSan Extension";
  };
  eventgrid = mkAzExtension rec {
    pname = "eventgrid";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/eventgrid-${version}-py2.py3-none-any.whl";
    sha256 = "662ca2a381efcf821a16648ff3b89edbe21f4e9887e18ffa7ee0dbbaf0332ede";
    description = "Microsoft Azure Command-Line Tools EventGrid Command Module";
  };
  express-route-cross-connection = mkAzExtension rec {
    pname = "express-route-cross-connection";
    version = "0.1.1";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/express_route_cross_connection-${version}-py2.py3-none-any.whl";
    sha256 = "b83f723baae0ea04557a87f358fa2131baf15d45cd3aba7a9ab42d14ec80df38";
    description = "Manage customer ExpressRoute circuits using an ExpressRoute cross-connection";
  };
  fleet = mkAzExtension rec {
    pname = "fleet";
    version = "1.0.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/fleet-${version}-py3-none-any.whl";
    sha256 = "cd93b819d0a8c1ab50f4aec00b31623fd01040362c4cd633a89ba03fc894eb73";
    description = "Microsoft Azure Command-Line Tools Fleet Extension";
  };
  fluid-relay = mkAzExtension rec {
    pname = "fluid-relay";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/fluid_relay-${version}-py3-none-any.whl";
    sha256 = "9217666f8134a38e09aeda905e7cc83994332a5ab563ec8935b9ff6c91563e8c";
    description = "Microsoft Azure Command-Line Tools FluidRelay Extension";
  };
  footprint = mkAzExtension rec {
    pname = "footprint";
    version = "1.0.0";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/footprint-${version}-py3-none-any.whl";
    sha256 = "4aa59288bf46cfd68519f1f7f63d3e33af16d80632b84c283cc7152129260b2c";
    description = "Microsoft Azure Command-Line Tools FootprintMonitoringManagementClient Extension";
  };
  front-door = mkAzExtension rec {
    pname = "front-door";
    version = "1.0.17";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/front_door-${version}-py3-none-any.whl";
    sha256 = "20996a4d864963451572b71fecf4906f3e7fe8f403a651a1d1e98363df63d095";
    description = "Manage networking Front Doors";
  };
  fzf = mkAzExtension rec {
    pname = "fzf";
    version = "1.0.2";
    url = "https://pahealyfzf.blob.core.windows.net/fzf/fzf-${version}-py2.py3-none-any.whl";
    sha256 = "84abeed03b4bbfa7b8c0be08d9366ff3040e2160df4f5a539f0e1c9e0a1c359c";
    description = "Microsoft Azure Command-Line Tools fzf Extension";
  };
  graphservices = mkAzExtension rec {
    pname = "graphservices";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/graphservices-${version}-py3-none-any.whl";
    sha256 = "8aeda3901e944b038f4e812b0b7099798d2bd82d55e03e785017a504c14583e5";
    description = "Microsoft Azure Command-Line Tools Graphservices Extension";
  };
  guestconfig = mkAzExtension rec {
    pname = "guestconfig";
    version = "0.1.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/guestconfig-${version}-py3-none-any.whl";
    sha256 = "94836a5d21ee1071cd40b163d2c80c32a6a81b9dc85d91371f7e4fb35141e273";
    description = "Microsoft Azure Command-Line Tools GuestConfigurationClient Extension";
  };
  hack = mkAzExtension rec {
    pname = "hack";
    version = "0.4.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/hack-${version}-py2.py3-none-any.whl";
    sha256 = "f9e600457e3a9fffc3235a7b30176d9f0a7f4d39ac01ea3e2668bcbdee6398a6";
    description = "Microsoft Azure Command-Line Tools Hack Extension";
  };
  hardware-security-modules = mkAzExtension rec {
    pname = "hardware-security-modules";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/hardware_security_modules-${version}-py3-none-any.whl";
    sha256 = "ac4a10e2cc64a4d0818e48ffbcddfeb4307dd56b8875bc01c02687d473c9fe9b";
    description = "Microsoft Azure Command-Line Tools AzureDedicatedHSMResourceProvider Extension";
  };
  hdinsightonaks = mkAzExtension rec {
    pname = "hdinsightonaks";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/hdinsightonaks-${version}-py3-none-any.whl";
    sha256 = "566c30d67d6b524ac25f77342121e0e7a6ed4ab0af561fcc6e94b0629a03f40c";
    description = "Microsoft Azure Command-Line Tools Hdinsightonaks Extension";
  };
  healthbot = mkAzExtension rec {
    pname = "healthbot";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/healthbot-${version}-py3-none-any.whl";
    sha256 = "9134fad2511516e714a5db346d63865af0badf0599ade3f1c15faca0055585a3";
    description = "Microsoft Azure Command-Line Tools HealthbotClient Extension";
  };
  healthcareapis = mkAzExtension rec {
    pname = "healthcareapis";
    version = "0.4.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/healthcareapis-${version}-py3-none-any.whl";
    sha256 = "a25d7d57d4fd3adcc37581d0acc1d6c6a46dcd0351933ed37cfba9d1abd60978";
    description = "Microsoft Azure Command-Line Tools HealthcareApisManagementClient Extension";
  };
  hpc-cache = mkAzExtension rec {
    pname = "hpc-cache";
    version = "0.1.5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/hpc_cache-${version}-py2.py3-none-any.whl";
    sha256 = "852cb417aadf0ad07e3c51413858c413bf71ea6cb49ba58289d9572f9a350507";
    description = "Microsoft Azure Command-Line Tools StorageCache Extension";
  };
  image-copy-extension = mkAzExtension rec {
    pname = "image-copy-extension";
    version = "0.2.13";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/image_copy_extension-${version}-py2.py3-none-any.whl";
    sha256 = "b0d12bf3c74500790d58d99a6c32562548712cb872b7942e8ad481e270521b19";
    description = "Support for copying managed vm images between regions";
  };
  image-gallery = mkAzExtension rec {
    pname = "image-gallery";
    version = "0.1.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/image_gallery-${version}-py2.py3-none-any.whl";
    sha256 = "6260c1f4bfb589d2ba0569317358a149caabbbd49a048e69328e44871694aacd";
    description = "Support for Azure Image Gallery";
  };
  import-export = mkAzExtension rec {
    pname = "import-export";
    version = "0.1.1";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/import_export-${version}-py3-none-any.whl";
    sha256 = "0680948362e12138c9582e68e471533482749bd660bfe3c8c2a4d856e90927b0";
    description = "Microsoft Azure Command-Line Tools StorageImportExport Extension";
  };
  init = mkAzExtension rec {
    pname = "init";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/init-${version}-py3-none-any.whl";
    sha256 = "1177fc293dc118b449b761ec2c728d39755fc3939de8d4bfd89cce1bfb218e86";
    description = "Microsoft Azure Command-Line Tools Init Extension";
  };
  internet-analyzer = mkAzExtension rec {
    pname = "internet-analyzer";
    version = "0.1.0rc6";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/internet_analyzer-${version}-py2.py3-none-any.whl";
    sha256 = "0708d9f598d1618d138eebcf18354d97c7b3a2c90570959df077e04d419d32c3";
    description = "Microsoft Azure Command-Line Tools Internet Analyzer Extension";
  };
  ip-group = mkAzExtension rec {
    pname = "ip-group";
    version = "0.1.2";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/ip_group-${version}-py2.py3-none-any.whl";
    sha256 = "afba2d8a8a612863b63f504d6cff6d559610b961e4c77dc2fd49b9fe03ec67a2";
    description = "Microsoft Azure Command-Line Tools IpGroup Extension";
  };
  k8s-extension = mkAzExtension rec {
    pname = "k8s-extension";
    version = "1.6.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/k8s_extension-${version}-py3-none-any.whl";
    sha256 = "27a9996a9ace11856f37719ae697f0ac98d368dde6eb8648d111aafc136599a7";
    description = "Microsoft Azure Command-Line Tools K8s-extension Extension";
  };
  kusto = mkAzExtension rec {
    pname = "kusto";
    version = "0.5.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/kusto-${version}-py3-none-any.whl";
    sha256 = "cf5729e9d02029a189182523543285c9737d515f41c610c8338d43f872f9f01d";
    description = "Microsoft Azure Command-Line Tools KustoManagementClient Extension";
  };
  log-analytics = mkAzExtension rec {
    pname = "log-analytics";
    version = "0.2.2";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/log_analytics-${version}-py2.py3-none-any.whl";
    sha256 = "c04c42a26d50db82d14f76e209184b18d4cce17b458817ac607e3ff975641eb2";
    description = "Support for Azure Log Analytics query capabilities";
  };
  log-analytics-solution = mkAzExtension rec {
    pname = "log-analytics-solution";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/log_analytics_solution-${version}-py2.py3-none-any.whl";
    sha256 = "c0a4252da4c29032c4e956b768860529509e88a1ecef7f3a3189cb701a305c6b";
    description = "Support for Azure Log Analytics Solution";
  };
  logic = mkAzExtension rec {
    pname = "logic";
    version = "1.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/logic-${version}-py3-none-any.whl";
    sha256 = "14c18768c02ee9c370ac7eed0f23206eee7d344a10382a3083b17b5e1848cfcd";
    description = "Microsoft Azure Command-Line Tools Logic Extension";
  };
  logz = mkAzExtension rec {
    pname = "logz";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/logz-${version}-py3-none-any.whl";
    sha256 = "6a937dbb8c5a758b29afd45ecfc101743a5bf2491f2fba60e8ea512d5b765840";
    description = "Microsoft Azure Command-Line Tools MicrosoftLogz Extension";
  };
  maintenance = mkAzExtension rec {
    pname = "maintenance";
    version = "1.5.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/maintenance-${version}-py3-none-any.whl";
    sha256 = "4f1336fed4fa2cbea640627676a6cab4399c1b29ae23cb21fe73c9bea0d80a7f";
    description = "Microsoft Azure Command-Line Tools MaintenanceManagementClient Extension";
  };
  managedccfs = mkAzExtension rec {
    pname = "managedccfs";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/managedccfs-${version}-py3-none-any.whl";
    sha256 = "378f425f35420373e9703a5dc8c0f05ca8176fb8404b38610d4de828f7c23d37";
    description = "Microsoft Azure Command-Line Tools Managedccfs Extension";
  };
  managednetworkfabric = mkAzExtension rec {
    pname = "managednetworkfabric";
    version = "4.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/managednetworkfabric-${version}-py3-none-any.whl";
    sha256 = "f80f528a099862fa8e792f770943a832dbb958b503cc5cc8cb6f58766056d857";
    description = "Support for managednetworkfabric commands based on 2023-06-15 API version";
  };
  managementpartner = mkAzExtension rec {
    pname = "managementpartner";
    version = "0.1.3";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/managementpartner-${version}-py2.py3-none-any.whl";
    sha256 = "22ddf4b1cdc77e99262cb6089c4d96040065828a1d38a2709fdb945d3c851839";
    description = "Support for Management Partner preview";
  };
  mixed-reality = mkAzExtension rec {
    pname = "mixed-reality";
    version = "0.0.5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/mixed_reality-${version}-py2.py3-none-any.whl";
    sha256 = "026aaf58f9ad02d74837d21a1f5c122264a59814e0b7c395c26e5fdc1293187e";
    description = "Mixed Reality Azure CLI Extension";
  };
  mobile-network = mkAzExtension rec {
    pname = "mobile-network";
    version = "0.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/mobile_network-${version}-py3-none-any.whl";
    sha256 = "66bd39f687c2ac030ab6bd44b8746ec8d64c4804b44592c0bb1ffda837dce22b";
    description = "Microsoft Azure Command-Line Tools MobileNetwork Extension";
  };
  monitor-control-service = mkAzExtension rec {
    pname = "monitor-control-service";
    version = "1.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/monitor_control_service-${version}-py3-none-any.whl";
    sha256 = "66475eb79c577ea566c74f986b9ef6af936580beb02dde622701370323d430a3";
    description = "Microsoft Azure Command-Line Tools MonitorClient Extension";
  };
  network-analytics = mkAzExtension rec {
    pname = "network-analytics";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/network_analytics-${version}-py3-none-any.whl";
    sha256 = "c8d7e195f913298ac03ef8eb1f8d7fb09526956d3eb750a8cd447ae8f61d4317";
    description = "Microsoft Azure Command-Line Tools NetworkAnalytics Extension";
  };
  networkcloud = mkAzExtension rec {
    pname = "networkcloud";
    version = "2.0.0b2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/networkcloud-${version}-py3-none-any.whl";
    sha256 = "28c43560516e254ab60708c0ac8cf868795ce76e4aa9da1548584b22331af467";
    description = "Support for Azure Operator Nexus network cloud commands based on 2023-10-01-preview API version";
  };
  new-relic = mkAzExtension rec {
    pname = "new-relic";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/new_relic-${version}-py3-none-any.whl";
    sha256 = "9ce69f1684cea14acba0f2fdb473e47e0a06745e383bb5144954c5e85e416199";
    description = "Microsoft Azure Command-Line Tools NewRelic Extension";
  };
  next = mkAzExtension rec {
    pname = "next";
    version = "0.1.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/next-${version}-py2.py3-none-any.whl";
    sha256 = "83c4e03427f190203e094c14e4f7e79cec989f1277e16b9256bb9fe688aa5e07";
    description = "Microsoft Azure Command-Line Tools Next Extension";
  };
  nginx = mkAzExtension rec {
    pname = "nginx";
    version = "0.1.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/nginx-${version}-py2.py3-none-any.whl";
    sha256 = "3234129a26043a68e80ee1ae31c36e7ef8b2691a096cd6fc557e3a46fea8170e";
    description = "Microsoft Azure Command-Line Tools Nginx Extension";
  };
  notification-hub = mkAzExtension rec {
    pname = "notification-hub";
    version = "1.0.0a1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/notification_hub-${version}-py3-none-any.whl";
    sha256 = "a03751b715700e0d18a38e808bfeed164335024c9608c4bfd53aeacc731d1099";
    description = "Microsoft Azure Command-Line Tools Notification Hub Extension";
  };
  nsp = mkAzExtension rec {
    pname = "nsp";
    version = "0.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/nsp-${version}-py3-none-any.whl";
    sha256 = "3e53051a70693a5da8c563118d0f695efc8465eab769ca64416fc8a16ba6e72a";
    description = "Microsoft Azure Command-Line Tools Nsp Extension";
  };
  offazure = mkAzExtension rec {
    pname = "offazure";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/offazure-${version}-py3-none-any.whl";
    sha256 = "1918817070ae9e0ceef57b93366d18b6e8bf577fd632e7da999e1e2abbb53656";
    description = "Microsoft Azure Command-Line Tools AzureMigrateV2 Extension";
  };
  orbital = mkAzExtension rec {
    pname = "orbital";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/orbital-${version}-py3-none-any.whl";
    sha256 = "4259fb8ff560440d63251cc9721bb3f2283452f2399134514611f886fa350f37";
    description = "Microsoft Azure Command-Line Tools Orbital Extension";
  };
  palo-alto-networks = mkAzExtension rec {
    pname = "palo-alto-networks";
    version = "1.1.1b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/palo_alto_networks-${version}-py3-none-any.whl";
    sha256 = "8d4f6a4b72366bd57780bd158d6c25b363999e1a13ea85d491809cc9a4d29608";
    description = "Microsoft Azure Command-Line Tools PaloAltoNetworks Extension";
  };
  peering = mkAzExtension rec {
    pname = "peering";
    version = "0.2.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/peering-${version}-py3-none-any.whl";
    sha256 = "b068c12b47f17304af51431a2ae975339b7d4601a180e83916efae73d7c42600";
    description = "Microsoft Azure Command-Line Tools PeeringManagementClient Extension";
  };
  portal = mkAzExtension rec {
    pname = "portal";
    version = "0.1.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/portal-${version}-py3-none-any.whl";
    sha256 = "3c3ebe23f59db5f2d286ca52cf8cfbbc5983ce8073622de11a35dab95800a996";
    description = "Microsoft Azure Command-Line Tools Portal Extension";
  };
  powerbidedicated = mkAzExtension rec {
    pname = "powerbidedicated";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/powerbidedicated-${version}-py2.py3-none-any.whl";
    sha256 = "e1e58bb6f57edde4793f4c66a0c10a2776f842172878162385f2b1d21539de6e";
    description = "Microsoft Azure Command-Line Tools PowerBIDedicated Extension";
  };
  providerhub = mkAzExtension rec {
    pname = "providerhub";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/providerhub-${version}-py3-none-any.whl";
    sha256 = "9cda8fed546254987e5c5f872b4119105796c89de8d65d385638dac155bdf01e";
    description = "Microsoft Azure Command-Line Tools ProviderHub Extension";
  };
  purview = mkAzExtension rec {
    pname = "purview";
    version = "0.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/purview-${version}-py3-none-any.whl";
    sha256 = "706cc2550fbd07b8b676345c2f26c5ba66550905bc8ec224c6c4e5637c497266";
    description = "Microsoft Azure Command-Line Tools PurviewManagementClient Extension";
  };
  qumulo = mkAzExtension rec {
    pname = "qumulo";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/qumulo-${version}-py3-none-any.whl";
    sha256 = "9973f580a3fc20cc2fe5558a1cfdc10ddfc6567982d12f37008bbfec7aafcf9b";
    description = "Microsoft Azure Command-Line Tools Qumulo Extension";
  };
  quota = mkAzExtension rec {
    pname = "quota";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/quota-${version}-py3-none-any.whl";
    sha256 = "8b4c3475df0c3544dbcc28e4875eb5b163d72b40aff4250aafdad94180c3f995";
    description = "Microsoft Azure Command-Line Tools AzureQuotaExtensionAPI Extension";
  };
  redisenterprise = mkAzExtension rec {
    pname = "redisenterprise";
    version = "0.1.4";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/redisenterprise-${version}-py3-none-any.whl";
    sha256 = "cb59ab44eb12b51ecc62f8a5b6302d166be5d6388cf8ff21bc49f2829128d031";
    description = "Microsoft Azure Command-Line Tools RedisEnterprise Extension";
  };
  reservation = mkAzExtension rec {
    pname = "reservation";
    version = "0.3.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/reservation-${version}-py3-none-any.whl";
    sha256 = "649f086b02305d142f2f08ea96f52a322a165a6f2a958f3287f53550938ab912";
    description = "Microsoft Azure Command-Line Tools Reservation Extension";
  };
  resource-graph = mkAzExtension rec {
    pname = "resource-graph";
    version = "2.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/resource_graph-${version}-py2.py3-none-any.whl";
    sha256 = "62c81e3d62ce60c5a0a485829d00bdb0c733145ee93fb6098c14e3b27ee27c40";
    description = "Support for querying Azure resources with Resource Graph";
  };
  resource-mover = mkAzExtension rec {
    pname = "resource-mover";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/resource_mover-${version}-py3-none-any.whl";
    sha256 = "3bc9f41aa30c4f6bc04ff780dc30e8df05bfc887f2adbdf9e89d59f8389e55f3";
    description = "Microsoft Azure Command-Line Tools ResourceMoverServiceAPI Extension";
  };
  sap-hana = mkAzExtension rec {
    pname = "sap-hana";
    version = "0.6.5";
    url = "https://github.com/Azure/azure-hanaonazure-cli-extension/releases/download/${version}/sap_hana-0.6.5-py2.py3-none-any.whl";
    sha256 = "b4554c125f3a0eb5c891cec396e7705f6e91d4d81789acef20e3c4d172fa4543";
    description = "Additional commands for working with SAP HanaOnAzure instances";
  };
  scenario-guide = mkAzExtension rec {
    pname = "scenario-guide";
    version = "0.1.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/scenario_guide-${version}-py3-none-any.whl";
    sha256 = "4264b48b4b980334488a3fdb3bc43241e828a2742c35ce48985f3bebf019e8f8";
    description = "Microsoft Azure Command-Line Tools Scenario Guidance Extension";
  };
  scheduled-query = mkAzExtension rec {
    pname = "scheduled-query";
    version = "0.5.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/scheduled_query-${version}-py2.py3-none-any.whl";
    sha256 = "b141ce4ff7678484561e9f3c842d8249112a465b7a0da07a6da49856920f8534";
    description = "Microsoft Azure Command-Line Tools Scheduled_query Extension";
  };
  scvmm = mkAzExtension rec {
    pname = "scvmm";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/scvmm-${version}-py2.py3-none-any.whl";
    sha256 = "565aa9d75dd4d276df2f8ffec5311bd2ae16a2d6172d525a7763fc5972b262b7";
    description = "Microsoft Azure Command-Line Tools SCVMM Extension";
  };
  self-help = mkAzExtension rec {
    pname = "self-help";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/self_help-${version}-py3-none-any.whl";
    sha256 = "a57d629f75443666af570188716eaf2b9182da41f6d2f958f6d53d79b830b23e";
    description = "Microsoft Azure Command-Line Tools SelfHelp Extension";
  };
  sentinel = mkAzExtension rec {
    pname = "sentinel";
    version = "0.2.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/sentinel-${version}-py3-none-any.whl";
    sha256 = "5511544b4e342b03a4a4263617c603d87442ad5179ce9d8c0d1fd10915f93b7a";
    description = "Microsoft Azure Command-Line Tools Sentinel Extension";
  };
  site-recovery = mkAzExtension rec {
    pname = "site-recovery";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/site_recovery-${version}-py3-none-any.whl";
    sha256 = "ab19142c9a2e06190b6dac272d8cf29e179c9e283f965f8e3a4d29275b847ce5";
    description = "Microsoft Azure Command-Line Tools SiteRecovery Extension";
  };
  spring = mkAzExtension rec {
    pname = "spring";
    version = "1.19.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/spring-${version}-py3-none-any.whl";
    sha256 = "80cbd41e563231e500670402b01e95150adce18b7c128320c3d2393284e0d5d5";
    description = "Microsoft Azure Command-Line Tools spring Extension";
  };
  spring-cloud = mkAzExtension rec {
    pname = "spring-cloud";
    version = "3.1.8";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/spring_cloud-${version}-py3-none-any.whl";
    sha256 = "14993abe3524c28a42b2e9ba0f0a8a7083162ba9174975e09d8cea834b9829ee";
    description = "Microsoft Azure Command-Line Tools spring-cloud Extension";
  };
  stack-hci = mkAzExtension rec {
    pname = "stack-hci";
    version = "1.1.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/stack_hci-${version}-py3-none-any.whl";
    sha256 = "9bb0350f6c28ac2068a5a4a20bbcf74ae34b392d05eb148c403c618525cbadef";
    description = "Microsoft Azure Command-Line Tools AzureStackHCIClient Extension";
  };
  stack-hci-vm = mkAzExtension rec {
    pname = "stack-hci-vm";
    version = "0.1.11";
    url = "https://hybridaksstorage.z13.web.core.windows.net/SelfServiceVM/CLI/stack_hci_vm-${version}.1-py3-none-any.whl";
    sha256 = "cc99134288545178d08b18abd5b7c9e3d099d2add8b52ab9308f6c5fd97ae60c";
    description = "Microsoft Azure Command-Line Tools AzureStackHCIClient Extension ";
  };
  staticwebapp = mkAzExtension rec {
    pname = "staticwebapp";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/staticwebapp-${version}-py3-none-any.whl";
    sha256 = "fb1dcd876fc2d829cc7a1cc545e9445364d43357d888bb3deeb36a716b805717";
    description = "Microsoft Azure Command-Line Tools Staticwebapp Extension";
  };
  storage-blob-preview = mkAzExtension rec {
    pname = "storage-blob-preview";
    version = "0.7.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/storage_blob_preview-${version}-py2.py3-none-any.whl";
    sha256 = "002b7779f4c6531fdb714f77bcea5d3d96007a7ff5b86869f8e56aad98298b23";
    description = "Microsoft Azure Command-Line Tools Storage-blob-preview Extension";
  };
  storage-mover = mkAzExtension rec {
    pname = "storage-mover";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/storage_mover-${version}-py3-none-any.whl";
    sha256 = "2682859ea376194a6942713ad673fd426555ce2d4ebe9545e45d18da4fed98b1";
    description = "Microsoft Azure Command-Line Tools StorageMover Extension";
  };
  storagesync = mkAzExtension rec {
    pname = "storagesync";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/storagesync-${version}-py2.py3-none-any.whl";
    sha256 = "1f6997e186199058e60d8fdc020c407d4f92d8e78286189c1887e57a371b43c1";
    description = "Microsoft Azure Command-Line Tools MicrosoftStorageSync Extension";
  };
  stream-analytics = mkAzExtension rec {
    pname = "stream-analytics";
    version = "1.0.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/stream_analytics-${version}-py3-none-any.whl";
    sha256 = "15443fd8a73d319a5c9fbc586c9727d1ce1a31e11fd3f3c7e4fcbc97ad076aaa";
    description = "Microsoft Azure Command-Line Tools StreamAnalyticsManagementClient Extension";
  };
  subscription = mkAzExtension rec {
    pname = "subscription";
    version = "0.1.5";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/subscription-${version}-py2.py3-none-any.whl";
    sha256 = "ff7896aebc46862a6d30ac5f4cf64bdd40cb50e5437cea299590896d75f1013e";
    description = "Support for subscription management preview";
  };
  support = mkAzExtension rec {
    pname = "support";
    version = "1.0.3";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/support-${version}-py2.py3-none-any.whl";
    sha256 = "9f5b4ebc6a90b48d2a3c18ce7b74d89240275dcf23aa836b8509882b1ee28c56";
    description = "Microsoft Azure Command-Line Tools Support Extension";
  };
  timeseriesinsights = mkAzExtension rec {
    pname = "timeseriesinsights";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/timeseriesinsights-${version}-py3-none-any.whl";
    sha256 = "c578804a6cfbb4ef8ab91de2130bba8f6139f2fadea4ed1e38b05ea62c7aa95d";
    description = "Microsoft Azure Command-Line Tools TimeSeriesInsightsClient Extension";
  };
  traffic-collector = mkAzExtension rec {
    pname = "traffic-collector";
    version = "0.1.2";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/traffic_collector-${version}-py3-none-any.whl";
    sha256 = "98bda4d9a9233efb0ae1c5fae1a6c2a42942e8a71b0ebf19d3a7193548b13ff2";
    description = "Microsoft Azure Command-Line Tools TrafficCollector Extension";
  };
  virtual-network-manager = mkAzExtension rec {
    pname = "virtual-network-manager";
    version = "1.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/virtual_network_manager-${version}-py3-none-any.whl";
    sha256 = "a18581c625791fb29736e7ec1b9e18d4a00f3765a8600192e10c892fd27b7ba1";
    description = "Microsoft Azure Command-Line Tools NetworkManagementClient Extension";
  };
  virtual-network-tap = mkAzExtension rec {
    pname = "virtual-network-tap";
    version = "0.1.0";
    url = "https://azurecliprod.blob.core.windows.net/cli-extensions/virtual_network_tap-${version}-py2.py3-none-any.whl";
    sha256 = "7e3f634f8eb701cf6fef504159785bc90e6f5bd2482e459469dd9ab30601aa35";
    description = "Manage virtual network taps (VTAP)";
  };
  virtual-wan = mkAzExtension rec {
    pname = "virtual-wan";
    version = "0.3.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/virtual_wan-${version}-py2.py3-none-any.whl";
    sha256 = "e5f4e9d4398cf0fcd656c0107386adbc8493e69e3158af6c5145ed23aaf77165";
    description = "Manage virtual WAN, hubs, VPN gateways and VPN sites";
  };
  vm-repair = mkAzExtension rec {
    pname = "vm-repair";
    version = "1.0.0b1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/vm_repair-${version}-py2.py3-none-any.whl";
    sha256 = "7e6b9fb9952a56811d65de87b87b0403a6161edfa82284a43fa58f176e397b8b";
    description = "Auto repair commands to fix VMs";
  };
  vmware = mkAzExtension rec {
    pname = "vmware";
    version = "6.0.1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/vmware-${version}-py2.py3-none-any.whl";
    sha256 = "2e07a4ddf1b244cfe8b63a29b7f82c3ec94294f10bacfe8fd604841d290020b5";
    description = "Azure VMware Solution commands";
  };
  webapp = mkAzExtension rec {
    pname = "webapp";
    version = "0.4.0";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/webapp-${version}-py2.py3-none-any.whl";
    sha256 = "908b0df07cef652176a0f2bf0fdcf58b5d16fb4903ee3c06f73f0bb3913a5c0f";
    description = "Additional commands for Azure AppService";
  };
  workloads = mkAzExtension rec {
    pname = "workloads";
    version = "0.1.0a1";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/workloads-${version}-py3-none-any.whl";
    sha256 = "0e5ba95c3799d043fc2ba869ce0c5b2eea200357a8b0cbd2b2733bb91d4cc7a8";
    description = "Microsoft Azure Command-Line Tools Workloads Extension";
  };
}
