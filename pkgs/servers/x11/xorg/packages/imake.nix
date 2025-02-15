{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "imake";
  version = "1.0.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "imake";
    rev = "refs/tags/imake-1.0.9";
    hash = "sha256-xt0gGSjkwnRZwfHnVrUhQcbAkZ4H8A/ewTAe1ueA83U=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
