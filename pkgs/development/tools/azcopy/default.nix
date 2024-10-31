{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.26.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-u6ngYEHqNVjz0YYkWhFnoQGCBRMHLdOzFTee8plwoDo=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-C8UopiCSp6qFeaDNE+w2QUKbSHALSSeV5WVo4lkLDrs=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    description = "New Azure Storage data transfer utility - AzCopy v10";
    homepage = "https://github.com/Azure/azure-storage-azcopy";
    changelog = "https://github.com/Azure/azure-storage-azcopy/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ colemickens kashw2 ];
  };
}
