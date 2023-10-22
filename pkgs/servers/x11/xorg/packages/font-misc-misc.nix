{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-misc";
  version = "1.1.3";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "misc-misc";
    rev = "refs/tags/font-misc-misc-1.1.3";
    hash = "sha256-WMBxUmCywfvi6UAXVzmjTOf94DSxxm2BZC2Bp/4a2bE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
