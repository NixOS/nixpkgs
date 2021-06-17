{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.11.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-mti93UDFgHQKJt3z1sjCkT71TZtwh2YnhTyUCi5tS5c=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-NEW1qXOxFPmDFUTciJkqwutZd3+sVkHgoZgQO8Gsdwk=";

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
