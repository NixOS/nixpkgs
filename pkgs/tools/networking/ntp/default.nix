{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation {
  name = "ntp-4.2.4";
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2.4.tar.gz;
    md5 = "eb9147d26cbe18bd8fbec07f1df55aef";
  };
  configureFlags = "
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  ";
  buildInputs = if stdenv.isLinux then [libcap] else [];
}
