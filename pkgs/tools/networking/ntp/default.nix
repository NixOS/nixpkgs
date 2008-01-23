{stdenv, fetchurl, libcap}:

assert stdenv.isLinux -> libcap != null;
 
stdenv.mkDerivation {
  name = "ntp-4.2.4p4";
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2.4p4.tar.gz;
    sha256 = "0im89i51ap7aqlhxq5isz5xg4h8w8ahwdhir8la3c83h3p47fcmv";
  };
  configureFlags = ''
    --without-crypto
    ${if stdenv.isLinux then "--enable-linuxcaps" else ""}
  '';
  buildInputs = if stdenv.isLinux then [libcap] else [];
}
