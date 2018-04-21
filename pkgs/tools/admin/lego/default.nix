{ lib, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  name = "lego-unstable-${version}";
  version = "2018-02-02";
  rev = "06a8e7c475c03ef8d4773284ac63357d2810601b";

  src = fetchFromGitHub {
    inherit rev;
    owner = "xenolf";
    repo = "lego";
    sha256 = "11a9gcgi3317z4lb1apkf6dnbjhf7xni0670nric3fbf5diqfwh2";
  };

  goPackagePath = "github.com/xenolf/lego";
  goDeps = ./deps.nix;

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = https://github.com/xenolf/lego;
    maintainers = with maintainers; [ andrew-d ];
  };
}
