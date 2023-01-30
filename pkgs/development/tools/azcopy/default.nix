{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.16.2";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-Pab4IYktNWWTudAY7Zx9dI+fRp0yihD78L0MmBHxeNY=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-OlsNFhduilo8fJs/mynrAiwuXcfCZERdaJk3VcAUCJw=";

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
