{ stdenv, fetchgit, libX11, libXScrnSaver, libXext, glib, dbus, pkgconfig, systemd }:

stdenv.mkDerivation {
  name = "lightum";
  src = fetchgit {
    url = https://github.com/poliva/lightum;
    rev = "123e6babe0669b23d4c1dfa5511088608ff2baa8";
    sha256 = "1r8c9mb82qgs8i7dczqx8fc7xrbn413b59xkqgjh4z1pfy75sl79";
  };

  buildInputs = [
    dbus
    glib
    libX11
    libXScrnSaver
    libXext
    pkgconfig
    systemd
  ];

  installPhase = ''
    make install prefix=$out bindir=$out/bin docdir=$out/share/doc \
      mandir=$out/share/man INSTALL="install -c" INSTALLDATA="install -c -m 644"
  '';

  meta = {
    description = "MacBook automatic light sensor daemon";
    homepage = https://github.com/poliva/lightum;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
