{ stdenv
, fetchFromGitHub
, lib
, perl
, sgx-sdk
, which
, openssl_3_0
, debug ? false
}:
let
  version = "3.0_Rev2";
in
stdenv.mkDerivation {
  pname = "sgx-ssl" + lib.optionalString debug "-debug";
  version = "${version}_${openssl_3_0.version}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-sgx-ssl";
    rev = "3.0_Rev2";
    hash = "sha256-dmLyaG6v+skjSa0KxLAfIfSBOxp9grrI7ds6WdGPe0I=";
  };

  postUnpack = ''
    ln -s ${openssl_3_0.src} $sourceRoot/openssl_source/openssl-${openssl_3_0.version}.tar.gz
  '';

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
    stdenv.cc.libc
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
