{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.19.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-NmiLNkecd5u8r1L6e3jdAGP4HCP1udWxM2jRZkFe1qI=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-XurlmsKblDCX3ldFEmYmK24NEfdw9ahiUWgsxYGwz48=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
