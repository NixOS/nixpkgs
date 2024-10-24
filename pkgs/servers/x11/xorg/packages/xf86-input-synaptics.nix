{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-synaptics";
  version = "1.9.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-input-synaptics";
    rev = "refs/tags/xf86-input-synaptics-1.9.2";
    hash = "sha256-9YtdKFQzHSeZ58oBMHoahdtNk9P1Rm59cTKWypUAczs=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
