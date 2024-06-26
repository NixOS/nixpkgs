{ lib
, stdenv
, fetchurl
, flex
, pcsclite
, pkg-config
, libusb1
, perl
, zlib
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ccid";
  version = "1.5.5";

  src = fetchurl {
    url = "https://ccid.apdu.fr/files/${pname}-${version}.tar.bz2";
    hash = "sha256-GUcI91/jadRd18Feiz6Kfbi0nPxVV1dMoqLnbvEsoMo=";
  };

  postPatch = ''
    patchShebangs .
    substituteInPlace src/Makefile.in --replace /bin/echo echo
  '';

  configureFlags = [
    "--enable-twinserial"
    "--enable-serialconfdir=${placeholder "out"}/etc/reader.conf.d"
    "--enable-ccidtwindir=${placeholder "out"}/pcsc/drivers/serial"
    "--enable-usbdropdir=${placeholder "out"}/pcsc/drivers"
  ];

  # error: call to undeclared function 'InterruptRead';
  # ISO C99 and later do not support implicit function declarations
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  nativeBuildInputs = [
    flex
    pkg-config
    perl
  ];

  buildInputs = [
    pcsclite
    libusb1
    zlib
  ];

  postInstall = ''
    install -Dm 0444 -t $out/lib/udev/rules.d src/92_pcscd_ccid.rules
    substituteInPlace $out/lib/udev/rules.d/92_pcscd_ccid.rules \
      --replace "/usr/sbin/pcscd" "${pcsclite}/bin/pcscd"
  '';

  # The resulting shared object ends up outside of the default paths which are
  # usually getting stripped.
  stripDebugList = ["pcsc"];

  passthru.updateScript = gitUpdater {
    url = "https://salsa.debian.org/rousseau/CCID.git";
  };

  meta = with lib; {
    description = "PC/SC driver for USB CCID smart card readers";
    homepage = "https://ccid.apdu.fr/";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = platforms.unix;
  };
}
