{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
  kernelModuleMakeFlags,
}:

stdenv.mkDerivation {
  pname = "rtl8814au";
  version = "${kernel.version}-unstable-2024-05-26";

  src = fetchFromGitHub {
    owner = "morrownr";
    repo = "8814au";
    rev = "810573647b837d88c4191597a0ea6d226f69f64c";
    hash = "sha256-AaOnUy3igocsCF/FNogn+z+QcQiid7U7XimE68wAco0=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  makeFlags = kernelModuleMakeFlags;

  hardeningDisable = [ "pic" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Realtek 8814AU USB WiFi driver";
    homepage = "https://github.com/morrownr/8814au";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.lassulus ];
    broken = kernel.kernelOlder "5.2" || kernel.kernelAtLeast "6.15";
  };
}
