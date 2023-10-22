{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-qxl";
  version = "0.1.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-qxl";
    rev = "refs/tags/xf86-video-qxl-0.1.6";
    hash = "sha256-g7NvAjmvPjyqUTXnZREDDs18O2e9Zl5hZeAza2a/1Jw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
