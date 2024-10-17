{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmodmap";
  version = "1.0.11";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xmodmap";
    rev = "refs/tags/xmodmap-1.0.11";
    hash = "sha256-rZy7A7TIXidXAJSLE453XNO/i/Yg83QqXAafUKOSSUM=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
