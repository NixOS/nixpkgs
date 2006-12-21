{stdenv, fetchurl}:
 
stdenv.mkDerivation {
  name = "ntp-4.2.2p4";
  src = fetchurl {
    url = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2.2p4.tar.gz;
    md5 = "916fe57525f8327f340b203f129088fa";
  };
}
