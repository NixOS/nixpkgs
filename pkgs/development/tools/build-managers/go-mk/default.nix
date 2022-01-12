{ lib
, buildGoPackage
, fetchFromGitHub
}:

buildGoPackage rec {
  pname = "go-mk";
  version = "0.pre+date=2015-03-24";

  src = fetchFromGitHub {
    owner = "dcjones";
    repo = "mk";
    rev = "73d1b31466c16d0a13a220e5fad7cd8ef6d984d1";
    hash = "sha256-fk2Qd3LDMx+RapKi1M9yCuxpS0IB6xlbEWW+H6t94AI=";
  };

  goPackagePath = "github.com/dcjones/mk";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "A reboot of Plan9's mk, written in Go";
    longDescription = ''
      Mk is a reboot of the Plan 9 mk command, which itself is a successor to
      make. This tool is for anyone who loves make, but hates all its stupid
      bullshit.
    '';
    license = licenses.bsd2;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
