{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "fping-3.4";

  src = fetchurl {
    url = "http://www.fping.org/dist/${name}.tar.gz";
    sha256 = "1zkawlk6lcqw6nakqnl3v0x1cwnxrx2lmg9q6j76mw9i96pjh9fl";
  };

  meta = {
    homepage = "http://fping.org/";
    description = "Send ICMP echo probes to network hosts";
  };
}
