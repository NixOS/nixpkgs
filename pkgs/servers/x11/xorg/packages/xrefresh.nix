{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xrefresh";
  version = "1.0.7";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xrefresh";
    rev = "refs/tags/xrefresh-1.0.7";
    hash = "sha256-5mUr/VxEyLbp35Xo+1UO6tgv9/5mHsZ5Qdv0jsBDPmY=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
