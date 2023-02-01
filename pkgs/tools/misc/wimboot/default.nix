{ lib, stdenv, fetchFromGitHub, libbfd, zlib, libiberty }:

stdenv.mkDerivation rec {
  pname = "wimboot";
  version = "2.7.5";

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "wimboot";
    rev = "v${version}";
    sha256 = "sha256-rbJONP3ge+2+WzCIpTUZeieQz9Q/MZfEUmQVbZ+9Dro=";
  };

  sourceRoot = "source/src";

  buildInputs = [ libbfd zlib libiberty ];
  makeFlags = [ "wimboot.x86_64.efi" ];

  NIX_CFLAGS_COMPILE = [
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
