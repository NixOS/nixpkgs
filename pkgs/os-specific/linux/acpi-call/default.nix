{ stdenv, fetchgit, kernel }:

stdenv.mkDerivation {
  name = "acpi-call-${kernel.version}";

  src = fetchgit {
    url = "git://github.com/mkottman/acpi_call.git";
    rev = "b570c3b6c7016174107558464e864391d8bbd176";
    sha256 = "a89c62d391b721bb87a094f81cefc77d9c80de4bb314bb6ea449c3ef2decad5e";
  };
  
  preBuild = ''
    sed -e 's/break/true/' -i test_off.sh
    sed -e 's@/bin/bash@.bin/sh@' -i test_off.sh
    sed -e "s@/lib/modules/\$(.*)@${kernel}/lib/modules/${kernel.modDirVersion}@" -i Makefile
  '';
 
  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    cp acpi_call.ko $out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $out/bin
    cp test_off.sh $out/bin/test_discrete_video_off.sh
    chmod a+x $out/bin/test_discrete_video_off.sh
  '';

  meta = {
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
  };
}
