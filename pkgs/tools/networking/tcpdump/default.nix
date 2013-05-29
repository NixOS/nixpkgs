{ stdenv, fetchurl, libpcap, enableStatic ? false }:

stdenv.mkDerivation rec {
  name = "tcpdump-4.4.0";

  src = fetchurl {
    url = "http://www.tcpdump.org/release/${name}.tar.gz";
    sha256 = "1g9h2p31xwpdg88v7wv9hc8calq8sjs25800vzd9i45q5knln9qj";
  };

  buildInputs = [ libpcap ];

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
