{ buildGoPackage
, lib
, fetchFromGitLab
}:

buildGoPackage rec {
  pname = "check-unstable";
  version = "2018-09-12";
  rev = "88db195993f8e991ad402754accd0635490769f9";

  goPackagePath = "gitlab.com/opennota/check";

  src = fetchFromGitLab {
    inherit rev;

    owner = "opennota";
    repo = "check";
    sha256 = "1983xmdkgpqda4qz8ashc6xv1zg5jl4zly3w566grxc5sfxpgf0i";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "A set of utilities for checking Go sources.";
    homepage = https://gitlab.com/opennota/check;
    license = licenses.gpl3;
    maintainers = with maintainers; [ kalbasit ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
