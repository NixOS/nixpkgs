{ stdenv, fetchFromGitHub, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "iio-sensor-proxy-${version}";
  version = "2.5";

  src = fetchFromGitHub {
    owner  = "hadess";
    repo   = "iio-sensor-proxy";
    rev    = version;
    sha256 = "06x1vvslsa44bgw8s5rr17q9i2ssbw0x04l75zsy3rql9r3y2jzg";
  };

  configurePhase = ''
    runHook preConfigure

    ./autogen.sh --prefix=$out \
      --with-udevrulesdir=$out/lib/udev/rules.d \
      --with-systemdsystemunitdir=$out/lib/systemd/system

    runHook postConfigure
  '';

  buildInputs = [
    glib
    gtk3
    gtk-doc
    libgudev
    systemd
  ];

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    gettext
    intltool
    libtool
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "Proxy for sending IIO sensor data to D-Bus";
    homepage = https://github.com/hadess/iio-sensor-proxy;
    license = licenses.gpl3 ;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    inherit version;
  };
}
