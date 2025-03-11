{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-jis-misc";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "jis-misc";
    rev = "refs/tags/font-jis-misc-1.0.4";
    hash = "sha256-2zhK+haW6/Q2hwQOHhHUlKwMCxBop3v5Pluf5uYweIE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
