{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-misc-meltho";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "misc-meltho";
    rev = "refs/tags/font-misc-meltho-1.0.4";
    hash = "sha256-a7k9Ip26r7wr/sPIA2yxmKdw8ugFrQjRZ0pGammet6o=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
