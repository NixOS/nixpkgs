{ stdenv, go, buildGoModule, fetchgit }:

buildGoModule rec {
  pname = "gopls";
  version = "0.4.1";

  src = fetchgit {
    rev = "gopls/v${version}";
    url = "https://go.googlesource.com/tools";
    sha256 = "18migk7arxm8ysfzidl7mdr069fxym9bfi6zisj7dliczw0qnkzv";
  };

  modRoot = "gopls";
  vendorSha256 = "1jaav6c5vybgks5hc164is0i7h097c5l75s7w3wi5a3zyzkbiyny";

  meta = with stdenv.lib; {
    description = "Official language server for the Go language";
    homepage = "https://github.com/golang/tools/tree/master/gopls";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mic92 ];
  };
}