{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.22.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-njDC1KxxWaeCxALF5MRE/6+z6bcEQt/PTjN29hEg4Hw=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-vHHUbXpO4Z2VKSyA8itywx5oei9bFuSmvW1d7KENeUM=";

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
