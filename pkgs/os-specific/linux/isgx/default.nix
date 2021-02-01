{ stdenv, lib, fetchFromGitHub, fetchpatch, kernel }:

stdenv.mkDerivation rec {
  name = "isgx-${version}-${kernel.version}";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "linux-sgx-driver";
    rev = "sgx_driver_${version}";
    hash = "sha256-zZ0FgCx63LCNmvQ909O27v/o4+93gefhgEE/oDr/bHw=";
  };

  patches = [
    # Fixes build with kernel >= 5.8
    (fetchpatch {
      url = "https://github.com/intel/linux-sgx-driver/commit/276c5c6a064d22358542f5e0aa96b1c0ace5d695.patch";
      sha256 = "sha256-PmchqYENIbnJ51G/tkdap/g20LUrJEoQ4rDtqy6hj24=";
    })
  ];

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

  meta = with lib; {
    description = "Intel SGX Linux Driver";
    homepage = "https://github.com/intel/linux-sgx-driver";
    license = with licenses; [ bsd3 gpl2 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = platforms.linux;
  };
}
