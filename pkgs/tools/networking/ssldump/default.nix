{ stdenv, fetchFromGitHub, openssl, libpcap }:

stdenv.mkDerivation {
  pname = "ssldump";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "adulau";
    repo = "ssldump";
    rev = "7491b9851505acff95b2c68097e9b9f630d418dc";
    sha256 = "1j3rln86khdnc98v50hclvqaq83a24c1rfzbcbajkbfpr4yxpnpd";
  };

  buildInputs = [ libpcap openssl ];
  prePatch = ''
    sed -i -e 's|#include.*net/bpf.h|#include <pcap/bpf.h>|' \
      base/pcap-snoop.c
  '';
  configureFlags = [ "--with-pcap-lib=${libpcap}/lib"
                     "--with-pcap-inc=${libpcap}/include"
                     "--with-openssl-lib=${openssl}/lib"
                     "--with-openssl-inc=${openssl}/include" ];
  meta = {
    description = "ssldump is an SSLv3/TLS network protocol analyzer";
    homepage = "http://ssldump.sourceforge.net";
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    platforms = stdenv.lib.platforms.linux;
  };
}
