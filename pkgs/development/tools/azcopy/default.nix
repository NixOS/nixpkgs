{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.3.4";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = version;
    sha256 = "16pdvcgy1d5dfqk3as23j45rkwfrv232n384cj5wfz9qwijkcy5g";
  };

  subPackages = [ "." ];

  modSha256 = "07cy2zi7m2pkbfdcy659x4k5j2w60cmjy8kxv1dcii3dc6ls4bvb";

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
