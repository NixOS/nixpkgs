{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcmsdb";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xcmsdb";
    rev = "refs/tags/xcmsdb-1.0.6";
    hash = "sha256-UlX1BC1rd3ds1q4mCkblYKAQ05OsrCcUPJbC6gdchg0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
