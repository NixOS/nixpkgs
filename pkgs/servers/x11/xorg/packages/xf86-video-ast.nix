{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-ast";
  version = "1.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-ast";
    rev = "refs/tags/xf86-video-ast-1.1.6";
    hash = "sha256-luTkyIOoaSdScFyMU6aaypoUaF1hZ7CMR7m8FWdkgac=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
