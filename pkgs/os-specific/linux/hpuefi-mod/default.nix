{
  stdenv,
  fetchzip,
  kernel,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hpuefi-mod";
  version = "3.05";

  src = fetchzip {
    url = "https://ftp.hp.com/pub/softpaq/sp150501-151000/sp150953.tgz";
    hash = "sha256-ofzqu5Y2g+QU0myJ4SF39ZJGXH1zXzX1Ys2FhXVTQKE=";
    stripRoot = false;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  strictDeps = true;

  makeFlags = [
    "KVERS=${kernel.modDirVersion}"
    "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "DESTDIR=$(out)"
  ];

  unpackPhase = ''
    tar -xzf "$src/non-rpms/hpuefi-mod-${finalAttrs.version}.tgz"
    cd hpuefi-mod-${finalAttrs.version}
  '';

  prePatch = ''
    substituteInPlace "Makefile" \
      --replace depmod \#
  '';

  meta = {
    homepage = "https://ftp.hp.com/pub/caps-softpaq/cmit/linuxtools/HP_LinuxTools.html";
    description = "Kernel module for managing BIOS settings and updating BIOS firmware on supported HP computers";
    license = lib.licenses.gpl2Only; # See "License" section in ./non-rpms/hpuefi-mod-*.tgz/README
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})
