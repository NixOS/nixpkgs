{ lib, stdenv, fetchurl,  openssl, libxcrypt }:

stdenv.mkDerivation rec {
  pname = "popa3d";
  version = "1.0.3";

  src = fetchurl {
    url = "http://www.openwall.com/popa3d/${pname}-${version}.tar.gz";
    sha256 = "1g48cd74sqhl496wmljhq44iyfpghaz363a1ip8nyhpjz7d57f03";
  };

  buildInputs = [ openssl libxcrypt ];

  patches = [
    ./fix-mail-spool-path.patch
    ./use-openssl.patch
    ./use-glibc-crypt.patch
    ./enable-standalone-mode.patch
  ];

  configurePhase = ''makeFlags="PREFIX=$out MANDIR=$out/share/man"'';

  meta = {
    homepage = "http://www.openwall.com/popa3d/";
    description = "Tiny POP3 daemon with security as the primary goal";
    platforms = lib.platforms.linux;
  };
}
