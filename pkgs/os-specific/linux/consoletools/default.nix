{ stdenv, fetchgit, SDL }:

stdenv.mkDerivation rec {
  name = "linuxconsoletools-${version}";
  version = "1.4.3";

  src = fetchgit {
    url = "git://linuxconsole.git.sourceforge.net/gitroot/linuxconsole/linuxconsole";
    rev = "dac2cae0e5795ddc27b76a92767dd9e07a10621e";
    sha256 = "350b008e614923dbd548fcaaf2842b39433acdcf595e2ce8aaf1599f076d331d";
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
