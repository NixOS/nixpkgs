{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.4.0";
  rev = "72e4a01eba4315301fd9ce00c8c2f492580ded8a";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "1sn6f638hgqpyd8rfyal3y6i6p21x4340jnhsvmgcd8lph49pplb";
  };

  modRoot = "gopls";
  vendorSha256 = "1zj0zpyl9wq23vks426vqg5xjwjcaj1079rkc67489h0p7y0aqv5";

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 ];
  };
}