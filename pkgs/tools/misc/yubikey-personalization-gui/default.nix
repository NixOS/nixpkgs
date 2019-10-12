{ stdenv, fetchurl, mkDerivation, pkgconfig, qtbase, qmake, imagemagick
, libyubikey, yubikey-personalization }:

mkDerivation rec {
  name = "yubikey-personalization-gui-3.1.25";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization-gui/Releases/${name}.tar.gz";
    sha256 = "1knyv5yss8lhzaff6jpfqv12fjf1b8b21mfxzx3qi0hw4nl8n2v8";
  };

  nativeBuildInputs = [ pkgconfig qmake imagemagick ];
  buildInputs = [ yubikey-personalization qtbase libyubikey ];

  installPhase = ''
    install -D -m0755 build/release/yubikey-personalization-gui "$out/bin/yubikey-personalization-gui"
    install -D -m0644 resources/lin/yubikey-personalization-gui.1 "$out/share/man/man1/yubikey-personalization-gui.1"

    # Desktop files
    install -D -m0644 resources/lin/yubikey-personalization-gui.desktop "$out/share/applications/yubikey-personalization-gui.desktop"
    install -D -m0644 resources/lin/yubikey-personalization-gui.desktop "$out/share/pixmaps/yubikey-personalization-gui.xpm"

    # Icons
    install -D -m0644 resources/lin/yubikey-personalization-gui.png "$out/share/icons/hicolor/128x128/apps/yubikey-personalization-gui.png"
    for SIZE in 16 24 32 48 64 96; do
      # set modify/create for reproducible builds
      convert -scale ''${SIZE} +set date:create +set date:modify \
        resources/lin/yubikey-personalization-gui.png \
        yubikey-personalization-gui.png

      install -D -m0644 yubikey-personalization-gui.png "$out/share/icons/hicolor/''${SIZE}x''${SIZE}/apps/yubikey-personalization-gui.png"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-personalization-gui;
    description = "A QT based cross-platform utility designed to facilitate reconfiguration of the Yubikey";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
