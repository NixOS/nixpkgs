{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bitstream-75dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bitstream-75dpi";
    rev = "refs/tags/font-bitstream-75dpi-1.0.4";
    hash = "sha256-y7/PvTle+9hq7lNtce9C62JrPPxcTxjHQ2oClRL0jKY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
