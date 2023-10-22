{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xfontsel";
  version = "1.1.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xfontsel";
    rev = "refs/tags/xfontsel-1.1.0";
    hash = "sha256-WJbmW7+EVpCTADwQ+MvhSrvlfdY1sCR+IkkJQoIfj0A=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
