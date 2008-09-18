{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation {
  name = "ntp-4.2.4p5";
  
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.4p5.tar.gz;
    sha256 = "066x8gm55cziyc86ciwdq68y2xqfbbqqh8417nkwd1jmrihfmjvl";
  };
  
  configureFlags = ''
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  '';
  
  buildInputs = if stdenv.isLinux then [libcap] else [];

  meta = {
    homepage = http://www.ntp.org/;
    description = "An implementation of the Network Time Protocol";
  };
}
