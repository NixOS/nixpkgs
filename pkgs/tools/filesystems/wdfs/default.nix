{
  lib,
  stdenv,
  fetchurl,
  glib,
  neon,
  fuse,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "wdfs-fuse";
  version = "1.4.2";

  src = fetchurl {
    url = "http://noedler.de/projekte/wdfs/wdfs-${version}.tar.gz";
    sha256 = "fcf2e1584568b07c7f3683a983a9be26fae6534b8109e09167e5dff9114ba2e5";
  };
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    fuse
    glib
    neon
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    # Fix the build on macOS with macFUSE installed. Needs autoreconfHook to
    # take effect.
    substituteInPlace configure.ac --replace \
      'export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH' ""
  '';

  meta = with lib; {
    homepage = "http://noedler.de/projekte/wdfs/";
    license = licenses.gpl2Plus;
    description = "User-space filesystem that allows to mount a webdav share";
    platforms = platforms.unix;
    mainProgram = "wdfs";
  };
}
