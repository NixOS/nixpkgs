{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xstdcmap";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xstdcmap";
    rev = "refs/tags/xstdcmap-1.0.5";
    hash = "sha256-MP9QrARwMMgzo0tKbJ10bSe6rU5+PzsMoK24khKKrX8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
