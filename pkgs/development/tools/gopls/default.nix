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
  modSha256 = "1p0g28i707xyxz1g6hb56qlc4km9ik7vjky0v80hw7n73vzs5mr9";

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 ];
  };
}
