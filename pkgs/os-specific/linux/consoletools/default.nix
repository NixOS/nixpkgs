{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  name = "linuxconsoletools-${version}";
  version = "1.4.8";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${name}.tar.bz2";
    sha256 = "0spf9hx48cqx2i46pkz0gbrn7xrk68cw8iyrfbs2b3k0bxcsri13";
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
