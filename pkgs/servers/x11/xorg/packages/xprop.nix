{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xprop";
  version = "1.2.6";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xprop";
    rev = "refs/tags/xprop-1.2.6";
    hash = "sha256-gXzQAgAkVHZXVZzad1hHxBM8Y33ll3Dwo5cI1AWs3RI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
