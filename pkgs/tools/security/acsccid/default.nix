{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, gettext
, flex
, perl
, pkg-config
, pcsclite
, libusb1
, libiconv
}:

stdenv.mkDerivation rec {
  version = "1.1.8";
  pname = "acsccid";

  src = fetchFromGitHub {
    owner = "acshk";
    repo = pname;
    rev = "v${version}";
    sha256 = "12aahrvsk21qgpjwcrr01s742ixs44nmjkvcvqyzhqb307x1rrn3";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    libtool
    gettext
    flex
    perl
  ];

  buildInputs = [
    pcsclite
    libusb1
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  configureFlags = [
    "--enable-usbdropdir=${placeholder "out"}/pcsc/drivers"
  ];

  doCheck = true;

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
  '';

  meta = with lib; {
    description = "PC/SC driver for Linux/Mac OS X and it supports ACS CCID smart card readers";
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
    maintainers = [ ];
    platforms = with platforms; unix;
  };
}
