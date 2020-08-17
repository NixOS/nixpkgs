{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.4.4";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "1h4ica6rwrdp5wg4ybpzvyvszj4m5l6w9hpvd9r2qcd9qdnqlykf";
  };

  modRoot = "gopls";
  vendorSha256 = "175051d858lsdir2hj5qcimp6hakbi9grpws1ssvk3r2jna27x1z";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 zimbatm ];
  };
}
