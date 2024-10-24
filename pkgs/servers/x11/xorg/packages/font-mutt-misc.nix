{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-mutt-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "mutt-misc";
    rev = "refs/tags/font-mutt-misc-1.0.4";
    hash = "sha256-hthR6XIF5PZFllf+Mclmcgv7tFZJhOL0hDlwRzYduco=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
