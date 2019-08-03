{ buildGoPackage
, lib
, fetchFromGitHub
}:

buildGoPackage rec {
  name = "impl-unstable-${version}";
  version = "2018-02-27";
  rev = "3d0f908298c49598b6aa84f101c69670e15d1d03";

  goPackagePath = "github.com/josharian/impl";

  src = fetchFromGitHub {
    inherit rev;

    owner = "josharian";
    repo = "impl";
    sha256 = "0xpip20x5vclrl0by1760lg73v6lj6nmkbiazlskyvpkw44h8a7c";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "impl generates method stubs for implementing an interface.";
    homepage = https://github.com/josharian/impl;
    license = licenses.mit;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
