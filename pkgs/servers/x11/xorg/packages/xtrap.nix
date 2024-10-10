{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xtrap";
  version = "1.0.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xtrap";
    rev = "refs/tags/xtrap-1.0.3";
    hash = "sha256-2lM6P6ZrtjnYJa58STC1wcTJ7tJr+Vi2L1FiiXMBbYA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
