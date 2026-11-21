{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kmod,
  gnugrep,
}:

stdenv.mkDerivation {
  pname = "vmware-host-modules";
  version = "workstation-26h1-${kernel.version}";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "vmware-host-modules";
    rev = "445dd811f354405e40ab59edc3c531c0535a5b83";
    hash = "sha256-dDw0XnvfDGzQ5/lYyDja8xUuarvXllE+xJOdTDt8E5M=";
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
    maintainers = with lib.maintainers; [
      deinferno
      vifino
    ];
  };
}
