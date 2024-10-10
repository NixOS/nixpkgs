{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lndir";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "lndir";
    rev = "refs/tags/lndir-1.0.4";
    hash = "sha256-6XlEjtvOoE+wxG8lkmIgYIQRGMVZOmAeQoefq5ntBME=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
