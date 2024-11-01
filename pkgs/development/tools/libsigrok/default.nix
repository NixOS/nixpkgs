{ lib
, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, libzip
, glib
, libusb1
, libftdi1
, check
, libserialport
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
  version = "0.5.2-unstable-2024-01-03";

  src = fetchgit {
    url = "git://sigrok.org/libsigrok";
    rev = "b503d24cdf56abf8c0d66d438ccac28969f01670";
    hash = "sha256-9EW0UCzU6MqBX6rkT5CrBsDkAi6/CLyS9MZHsDV+1IQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook doxygen pkg-config python ];
  buildInputs = [
    libzip glib libusb1 libftdi1 check libserialport glibmm hidapi
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ libieee1284 bluez ];

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
    maintainers = with maintainers; [ bjornfor vifino ];
  };
}
