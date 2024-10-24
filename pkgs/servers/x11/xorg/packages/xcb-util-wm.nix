{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-wm";
  version = "0.4.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-wm";
    rev = "refs/tags/xcb-util-wm-0.4.2";
    hash = "sha256-MKgArUOmwRRcMqLcVyNeZo3Z3BSNS4/9sc/w5nnFKZQ=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
