{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xvinfo";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xvinfo";
    rev = "refs/tags/xvinfo-1.1.5";
    hash = "sha256-RkwqDWBxzK76objMZ4a1lc2pLnrHsZfVLTmC2JFXky0=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
