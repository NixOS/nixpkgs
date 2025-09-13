{
  stdenv,
  lib,
  kernel,
  mft-pkg,
  ...
}:

with lib;

stdenv.mkDerivation rec {
  pname = "mft";

  inherit (mft-pkg) src version;

  postUnpack = ''
    mv mft-*-deb/SDEBS/kernel-mft-dkms*.deb .
    rm -rf mft-*-deb/*
    ar x kernel-mft-dkms*.deb
    (cd mft-*-deb; tar xvf ../data.tar.xz --strip-components=4;cat Makefile;cd -)
    ls -l $src
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = [
    "KPVER=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];
  installPhase =
    let
      destDir = "$out/lib/modules/${kernel.modDirVersion}/mst";
    in
    ''
      runHook preInstall

      mkdir -p ${destDir}

      mv ./mst_backward_compatibility/mst_pciconf/mst_pciconf.ko ${destDir}/.
      xz -f ${destDir}/mst_pciconf.ko
      mv ./mst_backward_compatibility/mst_pci/mst_pci.ko ${destDir}/.
      xz -f ${destDir}/mst_pci.ko

      runHook postInstall
    '';

  meta = with lib; {
    homepage = "https://network.nvidia.com/products/adapter-software/firmware-tools";
    description = "NVIDIA Firmware Tools, kernel package (mst_pci & mst_pciconf)";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ edwtjo ];
    platforms = [
      "x86_64-linux"
    ];
  };
}
