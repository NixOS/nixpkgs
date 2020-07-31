{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "azure-storage-azcopy";
  version = "10.5.1";

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-storage-azcopy";
    rev = "v${version}";
    sha256 = "0bygbg1k6926ri3988wbz0b1vv6wamk799mn5nkjf0xa6gjfqqsr";
  };

  subPackages = [ "." ];

  vendorSha256 = "10bpzf8f7ibx1wzd0nzh5q1ynwfjr4n1gjygq4zqqxg51ganqj82";

  postInstall = ''
    ln -rs "$out/bin/azure-storage-azcopy" "$out/bin/azcopy"
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ colemickens ];
    license = licenses.mit;
    description = "The new Azure Storage data transfer utility - AzCopy v10";
  };
}
