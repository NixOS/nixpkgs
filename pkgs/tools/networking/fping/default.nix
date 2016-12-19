{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.13";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "082pis2c2ad6kkj35zmsf6xb2lm8v8hdrnjiwl529ldk3kyqxcjb";
  };

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
    platforms = with stdenv.lib.platforms; all;
  };
}
