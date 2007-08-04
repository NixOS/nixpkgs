{stdenv, fetchurl, readline}:
stdenv.mkDerivation {
  name = "lftp-3.5.11";

  src = fetchurl {
    url = ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-3.5.11.tar.bz2;
    md5 = "a1691cc0b6f0045a61e9f3d4f668fe13";
  };

  buildInputs = [readline ];
}
