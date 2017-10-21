{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  name = "linuxconsoletools-${version}";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${name}.tar.bz2";
    sha256 = "0il1m8pgw8f6b8qid035ixamv0w5fgh9pinx5vw4ayxn03nyzlnf";
  };

  buildInputs = [ SDL ];

  makeFlags = [ "DESTDIR=$(out)"];

  installFlags = ''PREFIX=""'';

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/projects/linuxconsole/;
    description = "A set of tools for joysticks and serial peripherals";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ebzzry ];

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
