{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.9.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-IVbvBqp/7Y3La0pP6gbWl0ATfEvkCuR4J9ChTDPNhB0=";
  };

  subPackages = [ "." ];

  vendorSha256 = "sha256-mj1TvNuFFPJGAJCBTQtU5WWPhHbiXUxRiMZQ/XvEy0U=";

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
