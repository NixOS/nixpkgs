{ stdenv, fetchFromGitHub, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "2.7";

  src = fetchFromGitHub {
    owner  = "hadess";
    repo   = pname;
    rev    = version;
    sha256 = "05ipljw78d8z90cnkygcrpd0qq4vh14bb9hy06vqxnpdbyq46fxh";
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
