{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-75dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "adobe-75dpi";
    rev = "refs/tags/font-adobe-75dpi-1.0.4";
    hash = "sha256-pZ7Yt7UTAhlA9ITrPLbAccPphJ9wfiwa+NeR2B+PkXw=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
