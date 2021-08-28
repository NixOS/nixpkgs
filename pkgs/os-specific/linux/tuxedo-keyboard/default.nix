{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders}:

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "v${version}";
    sha256 = "123ady2bi2dwbajy3pgv10l3g2pyhi5k31c1ii0zcrvl2qqhndck";
  };

  buildInputs = [ linuxHeaders ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"
    mv src/tuxedo_keyboard.ko $out/lib/modules/${kernel.modDirVersion}
  '';

  meta = with lib; {
    description = "Full color keyboard driver for tuxedo computers laptops";
    homepage = "https://github.com/tuxedocomputers/tuxedo-keyboard/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.blanky0230 ];
  };
}
