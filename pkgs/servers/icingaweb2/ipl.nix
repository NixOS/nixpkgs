{ stdenvNoCC, lib, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "icingaweb2-ipl";
<<<<<<< HEAD
  version = "0.12.0";
=======
  version = "0.11.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Icinga";
    repo = "icinga-php-library";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Fk886oIQz9sbrPCA6AWN1OMh9uFmQPCTFWcbAUWZyXs=";
=======
    hash = "sha256-XvlLNCpCLALaw4iEtDCjkLEbqcY6uTnC20UnxIRIbII=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  installPhase = ''
    mkdir -p "$out"
    cp -r * "$out"
  '';

  meta = {
    description = "PHP library package for Icingaweb 2";
    homepage = "https://github.com/Icinga/icinga-php-library";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ das_j ];
  };
}
