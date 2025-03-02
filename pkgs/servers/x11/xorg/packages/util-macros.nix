{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "util-macros";
  version = "1.20.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "macros";
    rev = "refs/tags/util-macros-1.20.0";
    hash = "sha256-11h3Puo5OVmNN97Uz5rsvloA0lvrCWCjvAJSbQhYG1I=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
