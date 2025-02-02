{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.25.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "refs/tags/v${version}";
    hash = "sha256-OjNezXjC9SyRV+8CDkKtIm7Mzks+Quuj92M7tR0LZX0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-/SNQl80szkOZwtRHVxyAmapCFxDwQBM0Go6p0ILrKRM=";

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
