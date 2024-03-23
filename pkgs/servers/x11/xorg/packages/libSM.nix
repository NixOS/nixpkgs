{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libSM";
  version = "1.2.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libSM";
    rev = "refs/tags/libSM-1.2.4";
    hash = "sha256-NR8uqXaYI1tUekG7dxvd4vTxy9N33RTOGrDuxL6qYUU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
