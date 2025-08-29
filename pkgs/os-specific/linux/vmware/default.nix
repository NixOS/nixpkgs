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
  version = "workstation-17.6.3-20250728-${kernel.version}";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "vmware-host-modules";
    rev = "6797e552638a28d1fa1e9ebd7ab5d3c628671ba0";
    hash = "sha256-KCLxAF6UtNIdKcDoANviln2RJuz1Ld8jq5QFW9ONghs=";
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
