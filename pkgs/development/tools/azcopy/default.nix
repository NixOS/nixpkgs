{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.14.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-9NuX4BbQx/ZeWvyTxlZjrb7ETwSFwBpfDcSt8qvKAxE=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-9ThsJySzsyS0eX/0BlAAvtaeJpPYCP0cN1YgIShYrKw=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
