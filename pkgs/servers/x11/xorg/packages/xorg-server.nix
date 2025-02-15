{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-server";
  version = "21.1.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "";
    repo = "xserver";
    rev = "refs/tags/xorg-server-21.1.8";
    hash = "";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
