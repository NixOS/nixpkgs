{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.6.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "1gmpdyc55mkzdkkhyzvy9517znvcj8hd9x3rpkpr86vfzgjv9qyv";
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
