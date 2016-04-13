{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  name = "linuxconsoletools-${version}";
  version = "1.4.9";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${name}.tar.bz2";
    sha256 = "0rwv2fxn12bblp096m9jy1lhngz26lv6g6zs4cgfg4frikwn977s";
  };

  buildInputs = [ SDL ];
  makeFlags = [ "DESTDIR=$(out)"];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/linuxconsole/;
    description = "A set of tools for joysticks and serial peripherals";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];

    longDescription = ''
      The included tools are:

      ffcfstress(1)  - force-feedback stress test
      ffmvforce(1)   - force-feedback orientation test
      ffset(1)       - force-feedback configuration tool
      fftest(1)      - general force-feedback test
      jstest(1)      - joystick test
      jscal(1)       - joystick calibration tool
      inputattach(1) - connects legacy serial devices to the input layer
    '';
  };
}
