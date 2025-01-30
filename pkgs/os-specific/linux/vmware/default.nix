{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  gnugrep,
}:

stdenv.mkDerivation rec {
  pname = "vmware-modules";
  version = "workstation-17.6.1-unstable-2024-10-12-${kernel.version}";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "vmware-host-modules";
    # Developer no longer provides tags for kernel compatibility fixes
    # Commit hash for branch workstation-17.6.1 as of 2024-10-15
    rev = "3a7595bddb2239c2149d7f730a4b57c8bb120d99";
    hash = "sha256-YqRnym5bOZ2ApMegOAeiUNyhsEsF5g1TVALtkUz/v6E=";
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

  meta = with lib; {
    description = "Kernel modules needed for VMware hypervisor";
    homepage = "https://github.com/mkubecek/vmware-host-modules";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
    broken = (kernel.kernelOlder "5.5" && kernel.isHardened);
    maintainers = with maintainers; [
      deinferno
      vifino
    ];
  };
}
