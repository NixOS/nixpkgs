{stdenv, fetchurl, readline}:
stdenv.mkDerivation {
  name = "lftp-3.5.14";

  src = fetchurl {
    url = ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-3.5.14.tar.bz2;
    sha256 = "0hzrbhpgvndpd4wd08whfv1iqzbcijs1nxz40rhn651xabhiasrv";
  };

  buildInputs = [readline];
}
