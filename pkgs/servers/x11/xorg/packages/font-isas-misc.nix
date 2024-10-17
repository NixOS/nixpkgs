{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-isas-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "isas-misc";
    rev = "refs/tags/font-isas-misc-1.0.4";
    hash = "sha256-4by08nay+dfh3Soo0xoqCoQ5xVVqnm5nYP85LmSuEMA=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
