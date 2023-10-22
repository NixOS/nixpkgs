{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-lucidatypewriter-75dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-lucidatypewriter-75dpi";
    rev = "refs/tags/font-bh-lucidatypewriter-75dpi-1.0.4";
    hash = "sha256-AXAFs/vDlJurGYTZI0yE47+cB3mQctXXjPvzF2mOyvU=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
