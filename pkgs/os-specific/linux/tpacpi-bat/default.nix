{ lib, stdenv, fetchFromGitHub, perl, kmod, coreutils }:

# Requires the acpi_call kernel module in order to run.
stdenv.mkDerivation rec {
  pname = "tpacpi-bat";
<<<<<<< HEAD
  version = "3.2";
=======
  version = "3.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "teleshoes";
    repo = "tpacpi-bat";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-9XnvVNdgB5VeI3juZfc8N5weEyULXuqu1IDChZfQqFk=";
=======
    sha256 = "0wbaz34z99gqx721alh5vmpxpj2yxg3x9m8jqyivfi1wfpwc2nd5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    cp tpacpi-bat $out/bin
  '';

  postPatch = ''
    substituteInPlace tpacpi-bat \
      --replace modprobe ${kmod}/bin/modprobe \
      --replace cat ${coreutils}/bin/cat
  '';

  meta = {
    maintainers = [lib.maintainers.orbekk];
    platforms = lib.platforms.linux;
    description = "Tool to set battery charging thresholds on Lenovo Thinkpad";
    license = lib.licenses.gpl3Plus;
  };
}
