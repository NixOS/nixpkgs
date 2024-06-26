{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  kernel,
}:
let
  isKernelRT =
    (kernel.structuredExtraConfig ? PREEMPT_RT)
    && (kernel.structuredExtraConfig.PREEMPT_RT == lib.kernel.yes);
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "lkrg";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "lkrg-org";
    repo = "lkrg";
    rev = "v${version}";
    sha256 = "sha256-+yIKkTvfVbLnFBoXSKGebB1A8KqpaRmsLh8SsNuI9Dc=";
  };
  patches = [
    (fetchpatch {
      name = "fix-aarch64.patch";
      url = "https://github.com/lkrg-org/lkrg/commit/a4e5c00f13f7081b346bc3736e4c035e3d17d3f7.patch";
      sha256 = "sha256-DPscqi+DySHwFxGuGe7P2itPkoyb3XGu5Xp2S/ezP4Y=";
    })
  ];

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNEL=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  dontConfigure = true;

  prePatch = ''
    substituteInPlace Makefile --replace "KERNEL := " "KERNEL ?= "
  '';

  installPhase = ''
    runHook preInstall
    install -D lkrg.ko $out/lib/modules/${kernel.modDirVersion}/extra/lkrg.ko
    runHook postInstall
  '';

  meta = with lib; {
    description = "LKRG Linux Kernel module";
    longDescription = "LKRG performs runtime integrity checking of the Linux kernel and detection of security vulnerability exploits against the kernel.";
    homepage = "https://lkrg.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ chivay ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.10" || kernel.kernelAtLeast "6.1" || isKernelRT;
  };
}
