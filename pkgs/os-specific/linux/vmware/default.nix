{ lib, stdenv, fetchFromGitHub, kernel, kmod, gnugrep }:

stdenv.mkDerivation rec {
  pname = "vmware-modules";
  version = "workstation-17.0.2-2023-08-12-${kernel.version}";

  src = fetchFromGitHub {
    owner = "mkubecek";
    repo = "vmware-host-modules";
    # Developer no longer provides tags for kernel compatibility fixes
    # Commit hash for branch workstation-17.0.2 as of 2023-08-12
    rev = "8b2d31498a8df9b1215f407c989b065953b73455";
    sha256 = "sha256-R0nY4O3ASQkOop+ddU4k72HiIJU/aJz0l3lkJN/kuHc=";
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
    maintainers = with maintainers; [ deinferno ];
  };
}
