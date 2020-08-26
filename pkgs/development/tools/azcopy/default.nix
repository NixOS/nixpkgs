{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.6.0";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "0izjnbldgf0597j4rh2ir9jsc2nzp9vwxcgllvkm5lh1xqf6i0nf";
  };

  subPackages = [ "." ];

  vendorSha256 = "10sxkb2dh1il4ps15dlvq0xsry8hax27imb5qg3khdmjhb4yaj7k";

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
