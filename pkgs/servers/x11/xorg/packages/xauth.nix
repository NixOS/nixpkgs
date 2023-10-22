{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xauth";
  version = "1.1.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xauth";
    rev = "refs/tags/xauth-1.1.2";
    hash = "sha256-H/tO3PtQI4VrS1yJPOFWikjCa/H3E3JPs1KBuEU92dI=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
