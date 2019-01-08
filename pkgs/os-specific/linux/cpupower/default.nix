{ stdenv, buildPackages, kernel, pciutils, gettext }:

stdenv.mkDerivation {
  pname = "cpupower";
  inherit (kernel) version src;

  nativeBuildInputs = [ gettext ];
  buildInputs = [ pciutils ];

  postPatch = ''
    cd tools/power/cpupower
    sed -i 's,/bin/true,${buildPackages.coreutils}/bin/true,' Makefile
    sed -i 's,/bin/pwd,${buildPackages.coreutils}/bin/pwd,' Makefile
    sed -i 's,/usr/bin/install,${buildPackages.coreutils}/bin/install,' Makefile
  '';

  makeFlags = [ "CROSS=${stdenv.cc.targetPrefix}" ];

  installFlags = stdenv.lib.mapAttrsToList
    (n: v: "${n}=${placeholder "out"}/${v}") {
    bindir = "bin";
    sbindir = "sbin";
    mandir = "share/man";
    includedir = "include";
    libdir = "lib";
    localedir = "share/locale";
    docdir = "share/doc/cpupower";
    confdir = "etc";
    bash_completion_dir = "share/bash-completion/completions";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Tool to examine and tune power saving features";
    homepage = https://www.kernel.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
