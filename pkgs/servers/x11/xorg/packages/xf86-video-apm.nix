{ stdenv
, fetchFromGitLab
, lib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-apm";
  version = "1.3.0";
  builder = ../builder.sh;

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-apm";
    rev = "refs/tags/xf86-video-apm-1.3.0";
    hash = "sha256-Q10YmtxgWiFvMqvS0RKBhWPVqyFoWNjTe1RLvt7Kxlg=";
  };

  strictDeps = true;

  meta = {
    platforms = lib.platforms.unix;
  };
})
