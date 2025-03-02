{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xorgproto";
  version = "2023.2";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "proto";
    repo = "xorgproto";
    rev = "refs/tags/xorgproto-2023.2";
    hash = "sha256-KaikZaZkICrWRawkmVCSAH8/wMzy8f0oCoFmvXXC/iE=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
