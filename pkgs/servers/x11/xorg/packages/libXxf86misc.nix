{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXxf86misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXxf86misc";
    rev = "refs/tags/libXxf86misc-1.0.4";
    hash = "sha256-tcsjorikY2a1J4z7yl+/Qbhtsh2QmoPZ2zDv2a7N76k=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
