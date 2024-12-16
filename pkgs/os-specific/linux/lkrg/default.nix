{
  lib,
  stdenv,
  fetchFromGitHub,
  kernel,
}:
let
  isKernelRT =
    (kernel.structuredExtraConfig ? PREEMPT_RT)
    && (kernel.structuredExtraConfig.PREEMPT_RT == lib.kernel.yes);
in
stdenv.mkDerivation (finalAttrs: {
  name = "${finalAttrs.pname}-${finalAttrs.version}-${kernel.version}";
  pname = "lkrg";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "lkrg-org";
    repo = "lkrg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dxgkEj8HGOX4AMZRNbhv3utrNjKDFpp7kZmj17Wp2HE=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = kernel.makeFlags ++ [
    "KERNEL=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  enableParallelBuilding = true;
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
    broken = kernel.kernelOlder "5.10" || isKernelRT;
  };
})
