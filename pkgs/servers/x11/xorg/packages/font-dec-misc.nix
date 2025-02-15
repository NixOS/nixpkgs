{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-dec-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "dec-misc";
    rev = "refs/tags/font-dec-misc-1.0.4";
    hash = "sha256-1JRfZ8sR5esUSZE1ZTNQL5xTDIcSI2tZCsm8WDeJ43g=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
