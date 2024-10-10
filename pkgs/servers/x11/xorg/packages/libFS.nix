{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libFS";
  version = "1.0.9";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libFS";
    rev = "refs/tags/libFS-1.0.9";
    hash = "sha256-2J/KJjtnxo3PBUpvfCis9ngQBii/kkbpU2QgODipfvY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
