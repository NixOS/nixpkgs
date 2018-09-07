{ stdenv, buildPackages, kernel, pciutils, gettext }:

stdenv.mkDerivation {
  name = "cpupower-${kernel.version}";

  src = kernel.src;

  nativeBuildInputs = [ gettext ];
  buildInputs = [ pciutils ];

  postPatch = ''
    cd tools/power/cpupower
    sed -i 's,/bin/true,${buildPackages.coreutils}/bin/true,' Makefile
    sed -i 's,/bin/pwd,${buildPackages.coreutils}/bin/pwd,' Makefile
    sed -i 's,/usr/bin/install,${buildPackages.coreutils}/bin/install,' Makefile
  '';

  makeFlags = [ "CROSS=${stdenv.cc.targetPrefix}" ];

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
