{ stdenv, fetchgit, fetchpatch, kernel }:

stdenv.mkDerivation {
  name = "acpi-call-${kernel.version}";

  src = fetchgit {
    url = "git://github.com/mkottman/acpi_call.git";
    rev = "ac67445bc75ec4fcf46ceb195fb84d74ad350d51";
    sha256 = "0jl19irz9x9pxab2qp4z8c3jijv2m30zhmnzi6ygbrisqqlg4c75";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mkottman/acpi_call/pull/67.patch";
      sha256 = "0z07apvdl8nvl8iwfk1sl1iidfjyx12fc0345bmp2nq1537kpbri";
    })
  ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    sed -e 's/break/true/' -i examples/turn_off_gpu.sh
    sed -e 's@/bin/bash@.bin/sh@' -i examples/turn_off_gpu.sh
    sed -e "s@/lib/modules/\$(.*)@${kernel.dev}/lib/modules/${kernel.modDirVersion}@" -i Makefile
    sed -e 's@acpi/acpi[.]h@linux/acpi.h@g' -i acpi_call.c
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
