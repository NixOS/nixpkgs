{ stdenv, fetchurl,  openssl }:

stdenv.mkDerivation rec {

  name = "popa3d-1.0.2";

  src = fetchurl {
    url = "http://www.openwall.com/popa3d/${name}.tar.gz";
    sha256 = "0zvspgnlrx4jhhkb5b1p280nsf9d558jijgpvwfyvdp4q4v460z7";
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
    homepage = "http://www.openwall.com/popa3d/";
    description = "tiny POP3 daemon with security as the primary goal";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
