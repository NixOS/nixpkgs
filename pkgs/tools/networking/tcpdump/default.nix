{ stdenv, fetchurl, libpcap, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "tcpdump-4.7.4";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "1byr8w6grk08fsq0444jmcz9ar89lq9nf4mjq2cny0w9k8k21rbb";
  };

  buildInputs = [ libpcap ];

  crossAttrs = {
    LDFLAGS = if enableStatic then "-static" else "";
    configureFlags = [ "ac_cv_linux_vers=2" ] ++ (stdenv.lib.optional
      (stdenv.cross.platform.kernelMajor == "2.4") "--disable-ipv6");
  };

  meta = {
    description = "Network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
    maintainers = with stdenv.lib.maintainers; [ mornfall jgeerds ];
    platforms = stdenv.lib.platforms.linux;
  };
}
