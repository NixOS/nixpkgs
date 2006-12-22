{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation {
  name = "ntp-4.2.2p4";
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2.2p4.tar.gz;
    md5 = "916fe57525f8327f340b203f129088fa";
  };
  configureFlags = "
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  ";
  buildInputs = if stdenv.isLinux then [libcap] else [];
}
