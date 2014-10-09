{ stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  name = "linuxconsoletools-${version}";
  version = "1.4.7";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${name}.tar.bz2";
    sha256 = "1wgcmmjiqw3hh36jzvhgq07kq13ar2miafz02xshds2b0kdcz4s4";
  };

  buildInputs = [ SDL ];
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://sourceforge.net/projects/linuxconsole/";
    description = "A set of tools for joysticks and serial peripherals";
    license = stdenv.lib.licenses.gpl2Plus;

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
