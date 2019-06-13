{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "lego";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jxwdqqx6qn09jf658968s9vy9b59ji998j3x1hldq3w9wcrn6sn";
  };

  goPackagePath = "github.com/go-acme/lego";

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
