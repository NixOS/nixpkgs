{ stdenv, fetchFromGitHub, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkgconfig, systemd }:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "2.8";

  src = fetchFromGitHub {
    owner  = "hadess";
    repo   = pname;
    rev    = version;
    sha256 = "07rzm1z2p6lh4iv5pyp0p2x5805m9gsh19kcsjls3fi25p3a2c00";
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
    homepage = "https://github.com/hadess/iio-sensor-proxy";
    license = licenses.gpl3 ;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
    inherit version;
  };
}
