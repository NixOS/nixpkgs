{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xpr";
  version = "1.1.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xpr";
    rev = "refs/tags/xpr-1.1.0";
    hash = "sha256-N0QaMrYE0JD3l4QDcfrnpJE3fQGwGGTlmrzHtWMTEb4=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
