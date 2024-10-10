{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXft";
  version = "2.3.8";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXft";
    rev = "refs/tags/libXft-2.3.8";
    hash = "sha256-Kd3kjEJdSXGbhhCgrVvOD7JkI9QE1zY0Yon3DT0f66k=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
