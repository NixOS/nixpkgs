{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXtst";
  version = "1.2.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXtst";
    rev = "refs/tags/libXtst-1.2.4";
    hash = "sha256-Sn2p4JchyYEkZgTc2epzd3Nze4pWw+cHQf+T/tQFt3I=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
