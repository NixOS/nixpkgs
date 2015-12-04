{ stdenv, fetchurl, openssl, libpcap, python
, enableStatic ? false
}:

stdenv.mkDerivation rec {
  name = "vde2-2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/vde/vde2/2.3.1/${name}.tar.gz";
    sha256 = "14xga0ib6p1wrv3hkl4sa89yzjxv7f1vfqaxsch87j6scdm59pr2";
  };

  buildInputs = [ openssl libpcap python ];

  # Avoid qemu rebuild; feel free to replace with optional
  configureFlags = if enableStatic then [ "--enable-static" ] else null;

  meta = {
    homepage = http://vde.sourceforge.net/;
    description = "Virtual Distributed Ethernet, an Ethernet compliant virtual network";
  };
}
