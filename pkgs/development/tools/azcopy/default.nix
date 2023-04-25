{ stdenv, lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.18.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "sha256-fdJah0Y+VkZYI416vA8Pdr+oWnG17IhBwvMDm0vqiS0=";
  };

  subPackages = [ "." ];

  vendorHash = "sha256-F+tUsChcknI4j5/IM1FqMKsFmGHEKjthjzSitMPyc44=";

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
