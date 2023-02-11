{ lib, stdenv, fetchFromGitLab, autoconf-archive, gettext, libtool, intltool, autoconf, automake
, glib, gtk3, gtk-doc, libgudev, pkg-config, systemd }:

stdenv.mkDerivation rec {
  pname = "iio-sensor-proxy";
  version = "3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner  = "hadess";
    repo   = pname;
    rev    = version;
    sha256 = "0ngbz1vkbjci3ml6p47jh6c6caipvbkm8mxrc8ayr6vc2p9l1g49";
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
    pkg-config
  ];

  meta = with lib; {
    description = "Proxy for sending IIO sensor data to D-Bus";
    homepage = "https://gitlab.freedesktop.org/hadess/iio-sensor-proxy";
    license = licenses.gpl3 ;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.linux;
  };
}
