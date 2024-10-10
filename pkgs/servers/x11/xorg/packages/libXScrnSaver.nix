{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXScrnSaver";
  version = "1.2.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXScrnSaver";
    rev = "refs/tags/libXScrnSaver-1.2.4";
    hash = "sha256-RkCQuGk9M1eDZMTbHM+B3zmKvwaYV9IF0ogvO6VIN3c=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
