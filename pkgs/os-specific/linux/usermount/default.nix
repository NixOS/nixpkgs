{ stdenv, fetchgit, pkgconfig, dbus, libnotify, udisks2, gdk-pixbuf }:

stdenv.mkDerivation {
  name = "usermount-0.1";

  src = fetchgit {
    url = "https://github.com/tom5760/usermount.git";
    rev = "0d6aba3c1f8fec80de502f5b92fd8b28041cc8e4";
    sha256 = "0gpp0vwiwr7kgbhh26jspv3255662mnvnav6g8i2h0qxar8hf8w2";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ dbus libnotify udisks2 gdk-pixbuf ];

  NIX_CFLAGS_COMPILE = "-DENABLE_NOTIFICATIONS";

  installPhase = ''
    mkdir -p $out/bin
    mv usermount $out/bin/
  '';

  meta = {
    homepage = https://github.com/tom5760/usermount;
    description = "A simple tool to automatically mount removable drives using UDisks2 and D-Bus";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
