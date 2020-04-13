{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "3mux";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "aaronjanse";
    repo = pname;
    rev = "v${version}";
    sha256 = "1iz839w636vv7208wyrmb9r77wv9m0q1j8km06kmi87m0hcbh807";
  };

  modSha256 = "10lnzh22qzls1b4i9dbknbxw5v92bcs7sarqipvvk5fymadr3k2p";

  meta = with lib; {
    description = "Terminal multiplexer inspired by i3";
    homepage = "https://github.com/aaronjanse/3mux";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjanse filalex77 ];
  };
}
