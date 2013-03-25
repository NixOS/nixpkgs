{ stdenv, fetchurl, kernel, kmod}:

stdenv.mkDerivation rec {
  name = "iscsitarget-1.4.20.2-${kernel.version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/iscsitarget/iscsitarget/1.4.20.2/${name}.tar.gz";
    sha256 = "126kp0yc7vmvdbaw2xfav89340b0h91dvvyib5qbvyrq40n8wg0g";
  };
  
  KSRC = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";
  
  DESTDIR = "$(out)";
  
  preConfigure = ''
    export PATH=$PATH:${kmod}/sbin
    sed -i 's|/usr/|/|' Makefile
  '';
  
  buildInputs = [ kmod ];
  
  meta = {
    description = "iSCSI Enterprise Target (IET), software for building an iSCSI storage system on Linux";
    license = "GPLv2+";
    homepage = http://iscsitarget.sourceforge.net;
  };
}
