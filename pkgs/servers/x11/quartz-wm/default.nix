{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  pixman,
  pkg-config,
  util-macros,
  libXinerama,
  libAppleWM,
  xorgproto,
  libXrandr,
  libXext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quartz-wm";
  version = "1.3.2";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/xorg/app/quartz-wm.git";
    tag = "quartz-wm-${finalAttrs.version}";
    hash = "sha256-1+KZNeR4Gq2uWBHTN53PTITHuly1Z4buR+grzdVNwhs=";
  };

  configureFlags = [ "--enable-xplugin-dock-support" ];
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    util-macros
  ];
  buildInputs = [
    libXinerama
    libAppleWM
    xorgproto
    libXrandr
    libXext
    pixman
  ];

  meta = {
    license = lib.licenses.apple-psl20;
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ matthewbauer ];
    mainProgram = "quartz-wm";
  };
})
