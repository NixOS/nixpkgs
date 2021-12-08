{ lib, fetchFromGitHub, kernel, kernelAtLeast, buildModule}:

buildModule rec {
  pname = "isgx";
  version = "2.14";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx-driver";
    rev = "sgx_diver_${version}"; # Typo is upstream's.
    sha256 = "0kbbf2inaywp44lm8ig26mkb36jq3smsln0yp6kmrirdwc3c53mi";
  };

  hardeningDisable = [ "pic" ];

  installPhase = ''
    runHook preInstall
    install -D isgx.ko -t $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/intel/sgx
    runHook postInstall
  '';

  enableParallelBuilding = true;

  overridePlatforms = [ "x86_64-linux" ];

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
    license = with licenses; [ bsd3 /* OR */ gpl2Only ];
    maintainers = with maintainers; [ oxalica ];
  };
}
