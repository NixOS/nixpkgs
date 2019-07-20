{ stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, flex, perl, pkgconfig, pcsclite, libusb }:

stdenv.mkDerivation rec {
  version = "1.1.6";
  name = "acsccid-${version}";

  src = fetchFromGitHub {
    owner = "acshk";
    repo = "acsccid";
    rev = "26bc84c738d12701e6a7289ed578671d71cbf3cb";
    sha256 = "09k7hvcay092wkyf0hjsvimg1h4qzss1nk7m5yanlib4ldhw5g5c";
  };

  doCheck = true;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcsclite libusb autoconf automake libtool gettext flex perl ];

  postPatch = ''
    sed -e s_/bin/echo_echo_g -i src/Makefile.am
    patchShebangs src/convert_version.pl
    patchShebangs src/create_Info_plist.pl
  '';

  preConfigure = ''
    libtoolize --force
    aclocal
    autoheader
    automake --force-missing --add-missing
    autoconf
    configureFlags="$configureFlags --enable-usbdropdir=$out/pcsc/drivers"
  '';

  meta = with stdenv.lib; {
    description = "acsccid is a PC/SC driver for Linux/Mac OS X and it supports ACS CCID smart card readers.";
    longDescription = ''
      acsccid is a PC/SC driver for Linux/Mac OS X and it supports ACS CCID smart card
      readers. This library provides a PC/SC IFD handler implementation and
      communicates with the readers through the PC/SC Lite resource manager (pcscd).

      acsccid is based on ccid. See CCID free software driver for more
      information:
      https://ccid.apdu.fr/

      It can be enabled in /etc/nixos/configuration.nix by adding:
        services.pcscd.enable = true;
        services.pcscd.plugins = [ pkgs.acsccid ];
    '';
    homepage = src.meta.homepage;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ roberth ];
    platforms = with platforms; unix;
  };
}
