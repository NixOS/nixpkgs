{ stdenv, fetchgit, libX11, libXScrnSaver, libXext, glib, dbus, pkgconfig, systemd }:

stdenv.mkDerivation {
  name = "lightum-2014-06-07";
  src = fetchgit {
    url = https://github.com/poliva/lightum;
    rev = "123e6babe0669b23d4c1dfa5511088608ff2baa8";
    sha256 = "01x24rcrkgksyvqpgkr9zafg3jgs8nqng8yf0hx0kbmcimar8dbp";
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

  patchPhase = ''
    substituteInPlace Makefile \
      --replace "libsystemd-login" "libsystemd"
  '';

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
