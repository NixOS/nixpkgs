{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-utopia-75dpi";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "adobe-utopia-75dpi";
    rev = "refs/tags/font-adobe-utopia-75dpi-1.0.5";
    hash = "sha256-A/vMFfLh4nHsZsPpSIsbmtwBORbwBKMMibHZR6nAZis=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
