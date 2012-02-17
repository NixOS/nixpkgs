{ stdenv, fetchurl, kernel, module_init_tools}:

stdenv.mkDerivation rec {
  name = "iscsitarget-1.4.20.2-${kernel.version}";
  
  src = fetchurl {
    url = "mirror://sourceforge/iscsitarget/iscsitarget/1.4.20.2/${name}.tar.gz";
    sha256 = "126kp0yc7vmvdbaw2xfav89340b0h91dvvyib5qbvyrq40n8wg0g";
  };
  
  KSRC = "${kernel}/lib/modules/*/build";
  
  DESTDIR = "$(out)";
  
  preConfigure = ''
    export PATH=$PATH:${module_init_tools}/sbin
    sed -i 's|/usr/|/|' Makefile
  '';
  
  buildInputs = [ module_init_tools ];
  
  meta = {
    description = "iSCSI Enterprise Target (IET), software for building an iSCSI storage system on Linux";
    license = "GPLv2+";
    homepage = http://iscsitarget.sourceforge.net;
  };
}
