{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation rec {
  name = "ntp-4.2.6p2";
  
  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "1n79scfvgjk8hn1fr4q2kkk6xm83k68r4p488ai09nm20dwqp2a2";
  };
  
  configureFlags = ''
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  '';
  
  buildInputs = stdenv.lib.optional stdenv.isLinux libcap;

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
  };
}
