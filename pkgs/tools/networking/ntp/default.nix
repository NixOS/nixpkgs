{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation rec {
  name = "ntp-4.2.4p6";
  
  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "0rqhcmb9rjdl0hkvxyabnmlrzgvvw2f16k7mi9b4qskwgh340xk4";
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
