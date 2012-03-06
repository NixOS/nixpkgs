{ stdenv, fetchgit, kernel }:

stdenv.mkDerivation {
  name = "acpi-call-${kernel.version}";

  src = fetchgit {
    url = "git://github.com/mkottman/acpi_call.git";
    rev = "4f71ce83392bc52b3497";
    sha256 = "1f20516dc7d42bc7d9d71eaa54f48f38cd56b8683062f81d6f3857990056bdd3";
  };
  
  preBuild = ''
    sed -e 's/break/true/' -i test_off.sh
    sed -e 's@/bin/bash@.bin/sh@' -i test_off.sh
    sed -e "s@/lib/modules/\$(.*)@${kernel}/lib/modules/${kernel.version}@" -i Makefile
  '';
 
  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.version}/misc
    cp acpi_call.ko $out/lib/modules/${kernel.version}/misc
    mkdir -p $out/bin
    cp test_off.sh $out/bin/test_discrete_video_off.sh
  '';

  meta = {
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
  };
}
