{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iceauth";
  version = "1.0.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "iceauth";
    rev = "refs/tags/iceauth-1.0.9";
    hash = "sha256-BwLrKQn+xtCbixenOiXyUxuP8OGasp8doovFaLI+Q+w=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
