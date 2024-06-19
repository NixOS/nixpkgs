{ lib, stdenv, fetchFromGitHub , pkg-config
, pcsclite
, autoreconfHook
, libnfc
}:

stdenv.mkDerivation {
  pname = "ifdnfc";
  version = "2016-03-01";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "ifdnfc";
    rev = "0e48e8e";
    sha256 = "1cxnvhhlcbm8h49rlw5racspb85fmwqqhd3gzzpzy68vrs0b37vg";
  };
  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [ pcsclite libnfc ];

  configureFlags = [ "--prefix=$(out)" ];
  makeFlags = [ "DESTDIR=/" "usbdropdir=$(out)/pcsc/drivers" ];

  meta = with lib; {
    description = "PC/SC IFD Handler based on libnfc";
    mainProgram = "ifdnfc-activate";
    longDescription =
    '' libnfc Interface Plugin to be used in <code>services.pcscd.plugins</code>.
       It provides support for all readers which are not supported by ccid but by libnfc.

       For activating your reader you need to run
       <code>ifdnfc-activate yes<code> with this package in your
       <code>environment.systemPackages</code>

       To use your reader you may need to blacklist your reader kernel modules:
       <code>boot.blacklistedKernelModules = [ "pn533" "pn533_usb" "nfc" ];</code>

       Supports the pn533 smart-card reader chip which is for example used in
       the SCM SCL3711.
    '';
    homepage = "https://github.com/nfc-tools/ifdnfc";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ makefu ];
  };
}

