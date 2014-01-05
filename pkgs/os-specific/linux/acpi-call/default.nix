{ stdenv, fetchgit, kernel }:

stdenv.mkDerivation {
  name = "acpi-call-${kernel.version}";

  src = fetchgit {
    url = "git://github.com/mkottman/acpi_call.git";
    rev = "46dd97e115ddc7219c88b0818c4d5b235162fe6e";
    sha256 = "1bi0azd7xxhrivjhnmxllj2sfj12br56mxii20mnqdpqwyz0rhni";
  };
  
  preBuild = ''
    sed -e 's/break/true/' -i examples/turn_off_gpu.sh
    sed -e 's@/bin/bash@.bin/sh@' -i examples/turn_off_gpu.sh
    sed -e "s@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@" -i Makefile
  '';
 
  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/misc
    cp acpi_call.ko $out/lib/modules/${kernel.modDirVersion}/misc
    mkdir -p $out/bin
    cp examples/turn_off_gpu.sh $out/bin/test_discrete_video_off.sh
    chmod a+x $out/bin/test_discrete_video_off.sh
  '';

  meta = {
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    description = "A module allowing arbitrary ACPI calls; use case: hybrid video";
  };
}
