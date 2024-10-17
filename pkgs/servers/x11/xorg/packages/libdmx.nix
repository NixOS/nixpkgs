{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdmx";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libdmx";
    rev = "refs/tags/libdmx-1.1.5";
    hash = "sha256-138MvJtupKLNt1BlWHgfVYYG3Hj68NcN3rxZD4bPwaE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
