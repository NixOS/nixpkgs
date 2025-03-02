{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxkbfile";
  version = "1.1.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxkbfile";
    rev = "refs/tags/libxkbfile-1.1.2";
    hash = "sha256-/kzkrDlfg0M/dCDePX+BWQ2wRXoei9fI9k+FvW1SUbc=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
