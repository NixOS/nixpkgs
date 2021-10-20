{ lib, buildGoPackage, fetchgit }:

buildGoPackage rec {
  pname = "gosu";
  version = "2017-05-09";
  rev = "e87cf95808a7b16208515c49012aa3410bc5bba8";

  goPackagePath = "github.com/tianon/gosu";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/tianon/gosu";
    sha256 = "1qp1cfx0hrr4qlnh7rhjb4xlxv9697flmgzzl6jcdkrpk1f0bz8m";
  };

  goDeps = ./deps.nix;

  meta = {
    description= "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    homepage = "https://github.com/tianon/gosu";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
