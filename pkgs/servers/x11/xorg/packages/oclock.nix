{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "oclock";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "oclock";
    rev = "refs/tags/oclock-1.0.5";
    hash = "sha256-/nsF0QYO0m6popTxSBZYW6Xgvr0Atj2sw6tcG9X69fg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
