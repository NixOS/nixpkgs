{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "font-cronyx-cyrillic";
  version = "1.0.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "font";
    repo = "cronyx-cyrillic";
    rev = "refs/tags/font-cronyx-cyrillic-1.0.4";
    hash = "sha256-NXCHKXgHuvfGOM/AF1DXX7WOzjLl6XQPAmuTlmaU0S8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
