{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.23.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-Df45DHGA7EM4hx3iAmYNNUHjrUrkW6QniJkHaN7wNZM=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-afqDnrmbTR6yZHT7NysysORci4b0Oh0sjpftgAXJ5Uk=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    description = "The new Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens kashw2 ];
  };
}
