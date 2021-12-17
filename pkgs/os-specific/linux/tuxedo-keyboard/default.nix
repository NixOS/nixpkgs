{ lib, stdenv, fetchFromGitHub, kernel, linuxHeaders }:

stdenv.mkDerivation rec {
  pname = "tuxedo-keyboard-${kernel.version}";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "tuxedocomputers";
    repo = "tuxedo-keyboard";
    rev = "v${version}";
    sha256 = "1rv3ns4n61v18cpnp36zi47jpnqhj410yzi8b307ghiyriapbijv";
  };

  buildInputs = [ linuxHeaders ];

  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  installPhase = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}"

    for module in clevo_acpi.ko clevo_wmi.ko tuxedo_keyboard.ko tuxedo_io/tuxedo_io.ko; do
        mv src/$module $out/lib/modules/${kernel.modDirVersion}
    done
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
