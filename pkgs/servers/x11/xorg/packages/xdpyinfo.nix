{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdpyinfo";
  version = "1.3.4";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xdpyinfo";
    rev = "refs/tags/xdpyinfo-1.3.4";
    hash = "sha256-Mc51MF9oShyq57hgBwMKBJaTdvPZW79lu5pz8hM5B14=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
