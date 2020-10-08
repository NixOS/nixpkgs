{ stdenv, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.5.0";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "150jg1qmdszfvh1x5fagawgc24xy19xjg9y1hq3drwy7lfdnahmq";
  };

  modRoot = "gopls";
  vendorSha256 = "1s3d4hnbw0mab7njck79qmgkjn87vs4ffk44zk2qdrzqjjlqq5iv";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
