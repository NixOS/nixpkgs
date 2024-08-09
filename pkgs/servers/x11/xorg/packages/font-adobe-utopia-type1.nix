{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-adobe-utopia-type1";
  version = "1.0.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "adobe-utopia-type1";
    rev = "refs/tags/font-adobe-utopia-type1-1.0.5";
    hash = "sha256-ybBCqOTJ3b9/4XYWUcYz6xQY+v+1ZHHt1hTqDyQNgak=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
