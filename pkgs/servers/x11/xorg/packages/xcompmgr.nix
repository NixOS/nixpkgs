{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcompmgr";
  version = "1.1.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xcompmgr";
    rev = "refs/tags/xcompmgr-1.1.9";
    hash = "sha256-Ct/Ft1cQhOty0jM5q4lRttTxLl2yDcHhJCsQp60F8Ic=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
