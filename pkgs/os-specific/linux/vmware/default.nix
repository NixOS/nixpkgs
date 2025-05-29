{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  kernel,
  kmod,
  gnugrep,
}:

stdenv.mkDerivation {
  pname = "vmware-modules";
  version = "workstation-17.6.3-${kernel.version}";

  src = fetchFromGitHub {
    owner = "philipl";
    repo = "vmware-host-modules";
    rev = "93d8bf38d7e705a862dcbfa721884638a817d476";
    hash = "sha256-i2E3QAy5P3U+EqSaFaCQGuiU4vt/yYKv3oJBP1qK9Og=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      # https://github.com/philipl/vmware-host-modules/pull/1
      url = "https://github.com/amadejkastelic/vmware-host-modules/commit/926cfc50c017a099c796662c8e2820d12f94d0bb.patch";
      hash = "sha256-9XLhypr77Qy9Ty54Pm48DYYh3HT1WAmiwGOmBk3AfyI=";
    })
  ];

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
