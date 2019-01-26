{ stdenv, fetchurl, yacc, flex, libusb, libelf, libftdi1, readline
# docSupport is a big dependency, disabled by default
, docSupport ? false, texLive ? null, texinfo ? null, texi2html ? null
}:

assert docSupport -> texLive != null && texinfo != null && texi2html != null;

stdenv.mkDerivation rec {
  name = "avrdude-6.3";

  src = fetchurl {
    url = "mirror://savannah/avrdude/${name}.tar.gz";
    sha256 = "15m1w1qad3dj7r8n5ng1qqcaiyx1gyd6hnc3p2apgjllccdp77qg";
  };

  configureFlags = stdenv.lib.optionals docSupport "--enable-doc";

  buildInputs = [ yacc flex libusb libelf libftdi1 readline ]
    ++ stdenv.lib.optionals docSupport [ texLive texinfo texi2html ];

  meta = with stdenv.lib; {
    description = "Command-line tool for programming Atmel AVR microcontrollers";
    longDescription = ''
      AVRDUDE (AVR Downloader/UploaDEr) is an utility to
      download/upload/manipulate the ROM and EEPROM contents of AVR
      microcontrollers using the in-system programming technique (ISP).
    '';
    homepage = https://www.nongnu.org/avrdude/;
    license = licenses.gpl2Plus;
    platforms = with platforms; linux ++ darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
