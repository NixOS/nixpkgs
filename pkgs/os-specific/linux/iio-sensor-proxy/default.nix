{ stdenv, fetchFromGitHub, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  name = "iio-sensor-proxy-${version}";
  version = "2.4";

  src = fetchFromGitHub {
    owner  = "hadess";
    repo   = "iio-sensor-proxy";
    rev    = version;
    sha256 = "1c8izq73c00gvv0jc6zby5hcircs4cb16a1d3ivp1i1iflknj46n";
  };

  configurePhase = ''
    ./autogen.sh --prefix=$out \
      --with-udevrulesdir=$out/lib/udev/rules.d \
      --with-systemdsystemunitdir=$out/lib/systemd/system
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
