{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x11perf";
  version = "1.6.1";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "test";
    repo = "x11perf";
    rev = "refs/tags/x11perf-1.6.1";
    hash = "sha256-pr0V2F8dSsvABhUq4W04IsLBQSL0CdXX5IJKaVL0ztw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
