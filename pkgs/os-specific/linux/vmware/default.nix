{ lib, stdenv, fetchFromGitHub, kernel, kmod, gnugrep }:

stdenv.mkDerivation rec {
  pname = "vmware-modules";
  version = "workstation-17.6.0-unstable-2024-09-11-${kernel.version}";

  src = fetchFromGitHub {
    owner = "64kramsystem";
    repo = "vmware-host-modules-fork";
    # Developer no longer provides tags for kernel compatibility fixes
    # Commit hash for branch workstation-17.6.0-sav sans linkdown patch as of 2024-09-19
    rev = "e8759ff3e7e42b1d79ef3f417d293b7ee0d59c6a";
    hash = "sha256-tti6x9M1wTmjCO+ayfq6jpntiP4NMPH3JD0oGQ12rdI=";
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
    maintainers = with maintainers; [ deinferno vifino ];
  };
}
