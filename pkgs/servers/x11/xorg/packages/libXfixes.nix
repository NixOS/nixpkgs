{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXfixes";
  version = "6.0.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXfixes";
    rev = "refs/tags/libXfixes-6.0.1";
    hash = "sha256-kZNdl8/I1m7uptLITRTa+2u5FQhJKKqtVM7fgPe0gAE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
