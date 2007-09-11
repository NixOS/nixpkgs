{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation {
  name = "ntp-4.2.4p3";
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2.4p3.tar.gz;
    sha256 = "077y1hw6v0qnp3j3w3pcxgsc76waswqhwsbzfj3jqc79jfh65jv9";
  };
  configureFlags = "
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  ";
  buildInputs = if stdenv.isLinux then [libcap] else [];
}
