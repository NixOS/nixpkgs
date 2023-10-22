{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libICE";
  version = "1.1.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libICE";
    rev = "refs/tags/libICE-1.1.1";
    hash = "sha256-4dp3KIuiH2l8u104TVAoUcZC93QRAebU/JDLRxloSbM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
