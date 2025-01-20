{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-75dpi";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "bh-75dpi";
    rev = "refs/tags/font-bh-75dpi-1.0.4";
    hash = "sha256-BUMuntwO40x860IL6AnmagkO6PGSMo2JIqheRE3VdFg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
