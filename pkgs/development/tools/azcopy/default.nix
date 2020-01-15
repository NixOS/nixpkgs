{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "azure-storage-azcopy";
  version = "10.0.1-pre";
  revision = "10.0.1";
  goPackagePath = "github.com/Azure/azure-storage-azcopy";

  goDeps= ./deps.nix;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = revision;
    sha256 = "0v1qli01nnx81186q1d2556w457qkbwypq6yy89ns52pqg941arp";
  };

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
