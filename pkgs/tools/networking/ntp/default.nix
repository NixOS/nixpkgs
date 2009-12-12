{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation rec {
  name = "ntp-4.2.6";
  
  src = fetchurl {
    url = "http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/${name}.tar.gz";
    sha256 = "04cam5l804ws6cs0ihlmx26n39vpap5wb39i1vxfff01mri4q38b";
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
