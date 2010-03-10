{ stdenv, fetchurl, libpcap, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "tcpdump-4.0.0";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "112j0d12l5zsq56akn4n23i98pwblfb7qhblk567ddbl0bz9xsaz";
  };

  buildInputs = [ libpcap ];

  patches = [ ./disable-ipv6.patch ];

  crossAttrs = {
    LDFLAGS = if enableStatic then "-static" else "";
    configureFlags = [ "ac_cv_linux_vers=2" ] ++ (stdenv.lib.optional
      (stdenv.cross.platform.kernelMajor == "2.4") "--disable-ipv6");
  };

  meta = {
    description = "tcpdump, a famous network sniffer";
    homepage = http://www.tcpdump.org/;
    license = "BSD-style";
  };
}
