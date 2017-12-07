{ stdenv, fetchurl,  openssl }:

stdenv.mkDerivation rec {

  name = "popa3d-1.0.3";

  src = fetchurl {
    url = "http://www.openwall.com/popa3d/${name}.tar.gz";
    sha256 = "1g48cd74sqhl496wmljhq44iyfpghaz363a1ip8nyhpjz7d57f03";
  };

  buildInputs = [ openssl ];

  patches = [
    ./fix-mail-spool-path.patch
    ./use-openssl.patch
    ./use-glibc-crypt.patch
    ./enable-standalone-mode.patch
  ];

  configurePhase = ''makeFlags="PREFIX=$out MANDIR=$out/share/man"'';

  meta = {
    homepage = http://www.openwall.com/popa3d/;
    description = "Tiny POP3 daemon with security as the primary goal";
    platforms = stdenv.lib.platforms.linux;
  };
}
