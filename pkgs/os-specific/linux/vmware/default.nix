{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  gnugrep,
}:

stdenv.mkDerivation {
  pname = "vmware-modules";
  version = "workstation-17.6.3-20250608-${kernel.version}";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "vmware-host-modules";
    rev = "e08764f84df3bd14407291e02346b7c5c54d0bf6";
    hash = "sha256-RDVKropC+VOv1uJijOGlLt6iqZI8Cm9aWlbmvZj2CSk=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace '/lib/modules/$(VM_UNAME)/misc' "$out/lib/modules/${kernel.modDirVersion}/misc" \
      --replace /sbin/modinfo "${kmod}/bin/modinfo" \
      --replace 'test -z "$(DESTDIR)"' "0"

    for module in "vmmon-only" "vmnet-only"; do
      substituteInPlace "./$module/Makefile" \
        --replace '/lib/modules/' "${kernel.dev}/lib/modules/" \
        --replace /bin/grep "${gnugrep}/bin/grep"
    done
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/misc"
  '';

  meta = {
    description = "Kernel modules needed for VMware hypervisor";
    homepage = "https://github.com/mkubecek/vmware-host-modules";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    broken = (kernel.kernelOlder "5.5" && kernel.isHardened);
    maintainers = with lib.maintainers; [
      deinferno
      vifino
    ];
  };
}
