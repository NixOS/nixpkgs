{ lib, stdenv, fetchFromGitHub, libbfd, zlib, libiberty }:

stdenv.mkDerivation rec {
  pname = "wimboot";
<<<<<<< HEAD
  version = "2.7.6";
=======
  version = "2.7.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "wimboot";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-AFPuHxcDM/cdEJ5nRJnVbPk7Deg97NeSMsg/qwytZX4=";
  };

  sourceRoot = "${src.name}/src";
=======
    sha256 = "sha256-rbJONP3ge+2+WzCIpTUZeieQz9Q/MZfEUmQVbZ+9Dro=";
  };

  sourceRoot = "source/src";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [ libbfd zlib libiberty ];
  makeFlags = [ "wimboot.x86_64.efi" ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ];

  installPhase = ''
    mkdir -p $out/share/wimboot/
    cp wimboot.x86_64.efi $out/share/wimboot
  '';

  meta = with lib; {
    homepage = "https://ipxe.org/wimboot";
    description = "Windows Imaging Format bootloader";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ das_j ajs124 ];
    platforms = [ "x86_64-linux" ];
  };
}
