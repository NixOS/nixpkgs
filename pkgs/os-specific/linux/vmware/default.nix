{ lib, stdenv, fetchFromGitHub, kernel, kmod, gnugrep, vmware-workstation }:

stdenv.mkDerivation rec {
  pname = "vmware-modules";
  version = "${vmware-workstation.version}-${kernel.version}";

  src = fetchFromGitHub {
    owner = "mkubecek";
    repo = "vmware-host-modules";
    rev = "d9244035eb0638ea4602f3e50beb5d9a7f441d03"; # tip of branch workstation-16.2.4
    sha256 = "sha256-SJhHfHxxhOlX2s2Nia5n+HB+/Th4fMDgxQjN/JHWKVc=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace '/lib/modules/$(VM_UNAME)/misc' "$out/lib/modules/${kernel.modDirVersion}/misc" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/modinfo "${kmod}/bin/modinfo" \
      --replace 'test -z "$(DESTDIR)"' "0"

    for module in "vmmon-only" "vmnet-only"; do
      substituteInPlace "./$module/Makefile" \
        --replace '/lib/modules/' "${kernel.dev}/lib/modules/" \
        --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
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
