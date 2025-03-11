{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libXfont";
  version = "1.5.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "lib";
    repo = "libXfont";
    rev = "refs/tags/libXfont-1.5.4";
    hash = "sha256-qBJHQjm6OsKxq1oHEp0olJrfiFyld5FJzPq5pTDK/54=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
