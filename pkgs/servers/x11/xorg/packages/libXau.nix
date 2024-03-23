{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXau";
  version = "1.0.11";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXau";
    rev = "refs/tags/libXau-1.0.11";
    hash = "sha256-Oj+VTLw4xCCnz5Gc1kj0zDd+AmJldv89T95TiZGL0WM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
