{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXxf86vm";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXxf86vm";
    rev = "refs/tags/libXxf86vm-1.1.5";
    hash = "sha256-r0Ps/HRCfFMo7x14d/HZQRi1bopviEuAsQTjRfFAlIM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
