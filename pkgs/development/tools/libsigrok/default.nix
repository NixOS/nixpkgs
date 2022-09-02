{ lib
, stdenv
, fetchurl
, pkg-config
, libzip
, glib
, libusb1
, libftdi1
, check
, libserialport
, librevisa
, doxygen
, glibmm
, python
, hidapi
, libieee1284
, bluez
, sigrok-firmware-fx2lafw
}:

stdenv.mkDerivation rec {
  pname = "libsigrok";
  version = "0.5.2";

  src = fetchurl {
    url = "https://sigrok.org/download/source/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0g6fl684bpqm5p2z4j12c62m45j1dircznjina63w392ns81yd2d";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ doxygen pkg-config python ];
  buildInputs = [
    libzip glib libusb1 libftdi1 check libserialport librevisa glibmm hidapi
  ] ++ lib.optionals stdenv.isLinux [ libieee1284 bluez ];

  strictDeps = true;

  postInstall = ''
    mkdir -p $out/etc/udev/rules.d
    cp contrib/*.rules $out/etc/udev/rules.d

    mkdir -p "$out/share/sigrok-firmware/"
    cp ${sigrok-firmware-fx2lafw}/share/sigrok-firmware/* "$out/share/sigrok-firmware/"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    # assert that c++ bindings are included
    # note that this is only true for modern (>0.5) versions; the 0.3 series does not have these
    [[ -f $out/include/libsigrokcxx/libsigrokcxx.hpp ]] \
      || { echo 'C++ bindings were not generated; check configure output'; false; }
  '';

  meta = with lib; {
    description = "Core library of the sigrok signal analysis software suite";
    homepage = "https://sigrok.org/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor ];
  };
}
