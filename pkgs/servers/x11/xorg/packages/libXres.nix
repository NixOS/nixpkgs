{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXres";
  version = "1.2.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXres";
    rev = "refs/tags/libXres-1.2.2";
    hash = "sha256-xJmRCcwQHOfJ8qH8pcJtnTU8iJ0UmqkbdlxTPU1vzM0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
