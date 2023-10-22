{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-xfree86-type1";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "xfree86-type1";
    rev = "refs/tags/font-xfree86-type1-1.0.5";
    hash = "sha256-lk1AuRAKJRMa3HxmgJjTvN6mv3Me9t6YeVTNrfLEA3c=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
