{
  mkAzExtension,
  python3Packages,
}:

{
  azure-devops = mkAzExtension rec {
    pname = "azure-devops";
    version = "1.0.0";
    url = "https://github.com/Azure/azure-devops-cli-extension/releases/download/20240206.1/azure_devops-${version}-py2.py3-none-any.whl";
    sha256 = "658a2854d8c80f874f9382d421fa45abf6a38d00334737dda006f8dec64cf70a";
    description = "Tools for managing Azure DevOps";
    propagatedBuildInputs = with python3Packages; [
      distro
    ];
  };
}
