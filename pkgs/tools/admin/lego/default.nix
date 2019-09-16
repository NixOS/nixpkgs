{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q73522yblcjsyscsppwnxfw6m249zr9whb93bhv5i5z012gy6mx";
  };

  modSha256 = "00pl8l8h01rfxyd0l4487x55kfqhpm0ls84kxmgz3vph7irm6hcq";

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
