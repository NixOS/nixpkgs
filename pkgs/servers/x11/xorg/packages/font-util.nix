{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-util";
  version = "1.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "util";
    rev = "refs/tags/font-util-1.4.1";
    hash = "sha256-cv6Whex1s4+J7Ue4IOHdO9WtrarTgSpLEghWpbUl+0o=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
