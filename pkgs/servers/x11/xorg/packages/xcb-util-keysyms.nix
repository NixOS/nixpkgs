{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-keysyms";
  version = "0.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-keysyms";
    rev = "refs/tags/xcb-util-keysyms-0.4.1";
    hash = "sha256-Dw6b9L8s8yo9VhS5ZqXVm+eeqL9kLemFRQMWag011ss=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
