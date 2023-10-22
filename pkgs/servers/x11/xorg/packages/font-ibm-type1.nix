{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-ibm-type1";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "ibm-type1";
    rev = "refs/tags/font-ibm-type1-1.0.4";
    hash = "sha256-TwTC4Z337D/ShIkN70q8DVqMySSe63ZvaGOKksuTfJo=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
