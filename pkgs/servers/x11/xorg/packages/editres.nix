{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "editres";
  version = "1.0.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "editres";
    rev = "refs/tags/editres-1.0.8";
    hash = "sha256-t0p9Ujfv3B96P9HPUsvPkD/IOWw7sOsD5p542m59rwE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
