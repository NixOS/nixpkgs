{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util";
  version = "0.4.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libxcb-util";
    rev = "refs/tags/xcb-util-0.4.1";
    hash = "sha256-glIAfKeIUN+5qV6mk6ts8GZLP0P5AffEQYrNxXWmBgo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
