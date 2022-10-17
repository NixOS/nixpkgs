{ lib
, stdenv
, symlinkJoin
, fetchFromGitHub
}:

let
  version = "2.61-1";
  mkSubProject = { subprj # The only mandatory argument
  , buildInputs ? []
  , src ? fetchFromGitHub {
    owner = "WiringPi";
    repo = "WiringPi";
    rev = version;
    sha256 = "sha256-VxAaPhaPXd9xYt663Ju6SLblqiSLizauhhuFqCqbO5M=";
  }
  }: stdenv.mkDerivation rec {
    pname = "wiringpi-${subprj}";
    inherit version src;
    sourceRoot = "source/${subprj}";
    inherit buildInputs;
    # Remove (meant for other OSs) lines from Makefiles
    preInstall = ''
      sed -i "/chown root/d" Makefile
      sed -i "/chmod/d" Makefile
    '';
    makeFlags = [
      "DESTDIR=${placeholder "out"}"
      "PREFIX=/."
      # On NixOS we don't need to run ldconfig during build:
      "LDCONFIG=echo"
    ];
  };
  passthru = {
    inherit mkSubProject;
    wiringPi = mkSubProject {
      subprj = "wiringPi";
    };
    devLib = mkSubProject {
      subprj = "devLib";
      buildInputs = [
        passthru.wiringPi
      ];
    };
    wiringPiD = mkSubProject {
      subprj = "wiringPiD";
      buildInputs = [
        passthru.wiringPi
        passthru.devLib
      ];
    };
    gpio = mkSubProject {
      subprj = "gpio";
      buildInputs = [
        passthru.wiringPi
        passthru.devLib
      ];
    };
  };
in

symlinkJoin {
  name = "wiringpi-${version}";
  inherit passthru;
  paths = [
    passthru.wiringPi
    passthru.devLib
    passthru.wiringPiD
    passthru.gpio
  ];
  meta = with lib; {
    description = "Gordon's Arduino wiring-like WiringPi Library for the Raspberry Pi (Unofficial Mirror for WiringPi bindings)";
    homepage = "https://github.com/WiringPi/WiringPi";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.linux;
  };
}
