{ lib, stdenv, fetchFromGitHub, libbfd, zlib, libiberty }:

stdenv.mkDerivation rec {
  pname = "wimboot";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "ipxe";
    repo = "wimboot";
    rev = "v${version}";
    sha256 = "12c677agkmiqs35qfpqfj7c4kxkizhbk9l6hig36dslzp4fwpl70";
  };

  sourceRoot = "source/src";

  buildInputs = [ libbfd zlib libiberty ];
  makeFlags = [ "wimboot.x86_64.efi" ];

  installPhase = ''
    mkdir -p $out/share/wimboot/
    cp wimboot.x86_64.efi $out/share/wimboot
  '';

  meta = with lib; {
    homepage = "https://ipxe.org/wimboot";
    description = "Windows Imaging Format bootloader";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ das_j ajs124 ];
    platforms = platforms.x86; # Fails on aarch64
  };
}
