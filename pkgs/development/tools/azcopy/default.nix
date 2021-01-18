{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.7.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "0l2109r9a8fhd66zgsi56zdmy390fpnvy08rbxf6rfc0a55n96ka";
  };

  subPackages = [ "." ];

  vendorSha256 = "032yzl8mmgmmxbpsymndp4ddgi572jh5drwql0bjjabp3yqwj1g1";

  doCheck = false;

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
