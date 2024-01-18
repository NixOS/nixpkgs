{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.22.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-mC6iAsUmnJeVIJPkoI/pNN6mujALW9qvQ4M7Wk9eLnQ=";
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
