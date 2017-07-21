{ stdenv, fetchurl, libpcap, enableStatic ? false
, hostPlatform
}:

stdenv.mkDerivation rec {
  name = "tcpdump-${version}";
  version = "4.9.0";

  src = fetchurl {
    #url = "http://www.tcpdump.org/release/${name}.tar.gz";
    url = "mirror://debian/pool/main/t/tcpdump/tcpdump_${version}.orig.tar.gz";
    sha256 = "0pjsxsy8l71i813sa934cwf1ryp9xbr7nxwsvnzavjdirchq3sga";
  };

  buildInputs = [ libpcap ];

  crossAttrs = {
    LDFLAGS = if enableStatic then "-static" else "";
    configureFlags = [ "ac_cv_linux_vers=2" ] ++ (stdenv.lib.optional
      (hostPlatform.platform.kernelMajor == "2.4") "--disable-ipv6");
  };

  meta = {
    description = "Network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ mornfall jgeerds ];
    platforms = stdenv.lib.platforms.linux;
  };
}
