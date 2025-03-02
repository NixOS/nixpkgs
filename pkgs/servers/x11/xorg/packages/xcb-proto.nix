{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-proto";
  version = "1.16.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "proto";
    repo = "xcbproto";
    rev = "refs/tags/xcb-proto-1.16.0";
    hash = "sha256-XbHFq4acP+0bfAwp5OfpwBkiZV8B+8gIocP6WGvkzaI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
