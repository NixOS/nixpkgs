{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorg-sgml-doctools";
  version = "1.12";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "doc";
    repo = "xorg-sgml-doctools";
    rev = "refs/tags/xorg-sgml-doctools-1.12";
    hash = "sha256-NdZITqY0mY3N5u3k+e1QGbOYL9nzNgu9kjfRCDaO+dk=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
