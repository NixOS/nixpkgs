{ stdenv, fetchFromGitHub, openssl, libpcap }:

stdenv.mkDerivation rec {
  name = "ssldump-${version}";
  version = "0.9b3";

  src = fetchFromGitHub {
    owner = "adulau";
    repo = "ssldump";
    rev = "4529d03a50d39d3697c3e39a3d6f6c9b29448aa0";
    sha256 = "0wwsamzxabfxcil5y2g4v2261vdspxlp12wz4xhji8607jbyjwr1";
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
    homepage = http://ssldump.sourceforge.net;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ aycanirican ];
    platforms = stdenv.lib.platforms.linux;
  };
}
