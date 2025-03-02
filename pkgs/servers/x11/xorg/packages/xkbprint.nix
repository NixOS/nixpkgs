{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbprint";
  version = "1.0.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbprint";
    rev = "refs/tags/xkbprint-1.0.6";
    hash = "sha256-s3CfI8V8YI1HJik3yLZawXNU6bHSkhp9fODtRjWaR7s=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
