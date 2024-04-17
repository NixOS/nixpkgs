{ stdenv, lib, fetchurl, kernel, flex, coccinelle, python3 }:

stdenv.mkDerivation rec {
  name = "drbd-${version}-${kernel.version}";
  version = "9.2.7";

  src = fetchurl {
    url = "https://pkg.linbit.com//downloads/drbd/9/drbd-${version}.tar.gz";
    sha256 = "1355ns10z0fjgqsdpf09qfy01j8lg2n7zy4kclmar3s798n3mh56";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [
    kernel.moduleBuildDependencies
    flex
    coccinelle
    python3
  ];

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "SPAAS=false"
  ];

  # 6.4 and newer provide a in-tree version of the handshake module https://www.kernel.org/doc/html/v6.4/networking/tls-handshake.html
  installPhase = ''
    runHook preInstall
    install -D drbd/drbd.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd
    install -D drbd/drbd_transport_tcp.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd
    install -D drbd/drbd_transport_lb-tcp.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd
    install -D drbd/drbd_transport_rdma.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd
    ${lib.optionalString (lib.versionOlder kernel.version "6.4") ''
      install -D drbd/drbd-kernel-compat/handshake/handshake.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/block/drbd
    ''}
    runHook postInstall
  '';

  postPatch = ''
    patchShebangs .
    substituteInPlace Makefile --replace 'SHELL=/bin/bash' 'SHELL=${builtins.getEnv "SHELL"}'
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/LINBIT/drbd";
    description = "LINBIT DRBD kernel module";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ birkb ];
    longDescription = ''
       DRBD is a software-based, shared-nothing, replicated storage solution
       mirroring the content of block devices (hard disks, partitions, logical volumes, and so on) between hosts.
    '';
  };
}
