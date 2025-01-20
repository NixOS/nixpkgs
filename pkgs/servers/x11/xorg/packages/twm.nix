{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "twm";
  version = "1.0.12";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "twm";
    rev = "refs/tags/twm-1.0.12";
    hash = "sha256-z0LUxC4R8j327PdWb/ktEy20RJUurBRfUTGuorc2kPo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
