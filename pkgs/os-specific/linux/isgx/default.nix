{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:

stdenv.mkDerivation rec {
  name = "isgx-${version}-${kernel.version}";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx-driver";
    rev = "sgx_diver_${version}"; # Typo is upstream's.
    sha256 = "0kbbf2inaywp44lm8ig26mkb36jq3smsln0yp6kmrirdwc3c53mi";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -D isgx.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/intel/sgx
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Intel SGX Linux Driver";
    longDescription = ''
      The linux-sgx-driver project (isgx) hosts an out-of-tree driver
      for the Linux* Intel(R) SGX software stack, which would be used
      until the driver upstreaming process is complete (before 5.11.0).

      It is used to support Enhanced Privacy Identification (EPID)
      based attestation on the platforms without Flexible Launch Control.
    '';
    homepage = "https://github.com/intel/linux-sgx-driver";
    license = with licenses; [
      bsd3 # OR
      gpl2Only
    ];
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    # This kernel module is now in mainline so newer kernels should
    # use that rather than this out-of-tree version (officially
    # deprecated by Intel)
    broken = kernel.kernelAtLeast "6.4";
  };
}
