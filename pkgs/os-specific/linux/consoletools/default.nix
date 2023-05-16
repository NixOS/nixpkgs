<<<<<<< HEAD
{ lib, stdenv, fetchurl, pkg-config, SDL, SDL2 }:

stdenv.mkDerivation rec {
  pname = "linuxconsoletools";
  version = "1.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${pname}-${version}.tar.bz2";
    sha256 = "sha256-TaKXRceCt9sY9fN8Sed78WMSHdN2Hi/HY2+gy/NcJFY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL2 ];
=======
{ lib, stdenv, fetchurl, SDL }:

stdenv.mkDerivation rec {
  pname = "linuxconsoletools";
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/linuxconsole/${pname}-${version}.tar.bz2";
    sha256 = "0d2r3j916fl2y7pk1y82b9fvbr10dgs1gw7rqwzfpispdidb1mp9";
  };

  buildInputs = [ SDL ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [ "DESTDIR=$(out)"];

  installFlags = [ "PREFIX=\"\"" ];

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/linuxconsole/";
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
