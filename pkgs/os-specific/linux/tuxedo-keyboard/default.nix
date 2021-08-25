{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders }:

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "v${version}";
    sha256 = "sha256-JloLwfJfDdVowx1hOehjxPbnaKBCAMn7SZe09SE03HU=";
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
    broken = stdenv.isAarch64;
    maintainers = [ maintainers.blanky0230 ];
  };
}
