{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "coredns";
  version = "1.6.9";

  goPackagePath = "github.com/coredns/coredns";

  src = fetchFromGitHub {
    owner = "coredns";
    repo = "coredns";
    rev = "v${version}";
    sha256 = "18c02ss0sxxg8lkhdmyaac2x5alfxsizf6jqhck8bqkf6hiyv5hc";
  };

  vendorSha256 = "0ykhqsz4a7bkkxcg7w23jl3qs36law1f8l1b5r3i26qlamibqxl7";

  meta = with stdenv.lib; {
    homepage = "https://coredns.io";
    description = "A DNS server that runs middleware";
    license = licenses.asl20;
    maintainers = with maintainers; [ rushmorem rtreffer deltaevo ];
  };
}