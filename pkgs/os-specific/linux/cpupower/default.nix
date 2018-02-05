{ stdenv, fetchurl, kernel, coreutils, pciutils, gettext }:

stdenv.mkDerivation {
  name = "cpupower-${kernel.version}";

  src = kernel.src;

  buildInputs = [ coreutils pciutils gettext ];

  postPatch = ''
    cd tools/power/cpupower
    sed -i 's,/bin/true,${coreutils}/bin/true,' Makefile
    sed -i 's,/bin/pwd,${coreutils}/bin/pwd,' Makefile
    sed -i 's,/usr/bin/install,${coreutils}/bin/install,' Makefile
  '';

  installFlags = [
    "bindir=$(out)/bin"
    "sbindir=$(out)/sbin"
    "mandir=$(out)/share/man"
    "includedir=$(out)/include"
    "libdir=$(out)/lib"
    "localedir=$(out)/share/locale"
    "docdir=$(out)/share/doc/cpupower"
    "confdir=$(out)/etc"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tool to examine and tune power saving features";
    homepage = https://www.kernel.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
