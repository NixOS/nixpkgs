{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "gosu";
  version = "unstable-2017-05-09";

  goPackagePath = "github.com/tianon/gosu";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = "e87cf95808a7b16208515c49012aa3410bc5bba8";
    sha256 = "sha256-Ff0FXJg3z8akof+/St1JJu1OO1kS5gMtxSRnCLpj4eI=";
  };

  goDeps = ./deps.nix;

  meta = {
    description= "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    homepage = "https://github.com/tianon/gosu";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
