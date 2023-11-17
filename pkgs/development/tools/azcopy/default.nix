{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.21.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-FdiDxWmCRkSOa+6A9XgKeyFGk/ba+BgFm3/ChERkYvk=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-F5YMPwdS2A5FAwuG1gfiAqBKapZ24VIGzJXnwojoDk0=";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with lib; {
    maintainers = with maintainers; [ colemickens kashw2 ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
