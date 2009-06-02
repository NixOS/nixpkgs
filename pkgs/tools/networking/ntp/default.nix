{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation rec {
  name = "ntp-4.2.4p7";
  
  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "1hq1iz54md8imc4a60jcmljlm5jk8ql7x40v7kbnc1ndwly8i0an";
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
