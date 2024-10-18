{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXrandr";
  version = "1.5.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXrandr";
    rev = "refs/tags/libXrandr-1.5.3";
    hash = "sha256-nc/Ytuh1g6YCLsywe0a0A2/E4nhVZPrCmHUNOV2Wpd0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
