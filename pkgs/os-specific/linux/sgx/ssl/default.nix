{ stdenv
, fetchFromGitHub
, fetchpatch
, fetchurl
, lib
, perl
, sgx-sdk
, which
, debug ? false
}:
let
  sgxVersion = sgx-sdk.versionTag;
  opensslVersion = "1.1.1l";
in
stdenv.mkDerivation rec {
  pname = "sgx-ssl" + lib.optionalString debug "-debug";
  version = "lin_${sgxVersion}_${opensslVersion}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-sgx-ssl";
    rev = version;
    hash = "sha256-ibPXs90ni2fkxJ09fNO6wWVpfCFdko6MjBFkEsyIih8=";
  };

  postUnpack =
    let
      opensslSourceArchive = fetchurl {
        url = "https://www.openssl.org/source/openssl-${opensslVersion}.tar.gz";
        hash = "sha256-C3o+XlnDSCf+DDp0t+yLrvMCuY+oAIjX+RU6oW+na9E=";
      };
    in
    ''
      ln -s ${opensslSourceArchive} $sourceRoot/openssl_source/openssl-${opensslVersion}.tar.gz
    '';

  patches = [
    # https://github.com/intel/intel-sgx-ssl/pull/111
    ./intel-sgx-ssl-pr-111.patch
  ];

  postPatch = ''
    patchShebangs Linux/build_openssl.sh

    # Run the test in the `installCheckPhase`, not the `buildPhase`
    substituteInPlace Linux/sgx/Makefile \
      --replace '$(MAKE) -C $(TEST_DIR) all' \
                'bash -c "true"'
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    perl
    sgx-sdk
    stdenv.glibc
    which
  ];

  makeFlags = [
    "-C Linux"
  ] ++ lib.optionals debug [
    "DEBUG=1"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  # Build the test app
  #
  # Running the test app is currently only supported on Intel CPUs
  # and will fail on non-Intel CPUs even in SGX simulation mode.
  # Therefore, we only build the test app without running it until
  # upstream resolves the issue: https://github.com/intel/intel-sgx-ssl/issues/113
  doInstallCheck = true;
  installCheckTarget = "all";
  installCheckFlags = [
    "SGX_MODE=SIM"
    "-C sgx/test_app"
    "-j 1" # Makefile doesn't support multiple jobs
  ];
  preInstallCheck = ''
    # Expects the enclave file in the current working dir
    ln -s sgx/test_app/TestEnclave.signed.so .
  '';

  meta = with lib; {
    description = "Cryptographic library for Intel SGX enclave applications based on OpenSSL";
    homepage = "https://github.com/intel/intel-sgx-ssl";
    maintainers = with maintainers; [ trundle veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = with licenses; [ bsd3 openssl ];
  };
}
