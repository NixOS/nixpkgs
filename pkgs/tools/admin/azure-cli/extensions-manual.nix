{ lib
, mkAzExtension
, mycli
, python3Packages
}:

{
  azure-devops = mkAzExtension rec {
    pname = "azure-devops";
    version = "1.0.0";
    url = "https://github.com/Azure/azure-devops-cli-extension/releases/download/20240206.1/azure_devops-${version}-py2.py3-none-any.whl";
    sha256 = "658a2854d8c80f874f9382d421fa45abf6a38d00334737dda006f8dec64cf70a";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [ distro ];
  };

  rdbms-connect = mkAzExtension rec {
    pname = "rdbms-connect";
    version = "1.0.6";
    url = "https://azcliprod.blob.core.windows.net/cli-extensions/rdbms_connect-${version}-py2.py3-none-any.whl";
    sha256 = "49cbe8d9b7ea07a8974a29ad90247e864ed798bed5f28d0e3a57a4b37f5939e7";
    description = "Support for testing connection to Azure Database for MySQL & PostgreSQL servers";
    propagatedBuildInputs = (with python3Packages; [
      pgcli
      psycopg2
      pymysql
      setproctitle
    ]) ++ [
      mycli
    ];
    meta.maintainers = with lib.maintainers; [ obreitwi ];
  };

  # Removed extensions
  blockchain = throw "The 'blockchain' extension for azure-cli was deprecated upstream"; # Added 2024-04-26
}
