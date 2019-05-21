{ stdenv, fetchFromGitHub, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "iio-sensor-proxy-${version}";
  version = "2.6";

  src = fetchFromGitHub {
    owner  = "hadess";
    repo   = "iio-sensor-proxy";
    rev    = version;
    sha256 = "1nk8h40g1n4m8z52zwl9rl2h4cfyk41s29x21nwblrvg5v7085iq";
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
