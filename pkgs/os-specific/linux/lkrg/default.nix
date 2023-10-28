{ fetchFromGitHub
, kernel
, lib
, stdenv
, umhLogOnly ? false
}:
let
  isKernelRT = (kernel.structuredExtraConfig ? PREEMPT_RT) && (kernel.structuredExtraConfig.PREEMPT_RT == lib.kernel.yes);
in
stdenv.mkDerivation rec {
  name = "${pname}-${version}-${kernel.version}";
  pname = "lkrg";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "lkrg-org";
    repo = "lkrg";
    rev = "v${version}";
    hash = "sha256-96ubxSc1JcvwYFC273gp9RHlu3+wFbKW3j1vThkNm5w=";
  };

  patches = lib.optional umhLogOnly ./umh-enforce-0-by-default.patch;

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
    broken = kernel.kernelOlder "5.10" || kernel.kernelAtLeast "6.6" || isKernelRT;
  };
}
