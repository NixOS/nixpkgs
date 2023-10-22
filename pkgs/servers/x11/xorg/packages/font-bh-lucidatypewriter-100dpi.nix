{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-lucidatypewriter-100dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-lucidatypewriter-100dpi";
    rev = "refs/tags/font-bh-lucidatypewriter-100dpi-1.0.4";
    hash = "sha256-kTyZ0BN/hi3WUhyohsIyxpfqVlLeSHEzXPMRJv7OwDY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
