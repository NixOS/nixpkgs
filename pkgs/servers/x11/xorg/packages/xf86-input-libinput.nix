{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-libinput";
  version = "1.4.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-libinput";
    rev = "refs/tags/xf86-input-libinput-1.4.0";
    hash = "sha256-NmBE2dRltfBXORw3wbq3IFn2ELuTs08bODRJBx1JvW0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
