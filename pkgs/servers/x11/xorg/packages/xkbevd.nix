{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xkbevd";
  version = "1.1.5";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "app";
    repo = "xkbevd";
    rev = "refs/tags/xkbevd-1.1.5";
    hash = "sha256-yIxmXtEkO8LzwB9NfbEGbskVDs4WiHTO8x/3922XRV8=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
