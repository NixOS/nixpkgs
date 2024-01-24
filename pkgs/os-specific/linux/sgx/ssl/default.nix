{ stdenv
, fetchFromGitHub
, fetchurl
, lib
, openssl
, perl
, sgx-sdk
, which
, debug ? false
}:
let
  sgxVersion = sgx-sdk.versionTag;
  opensslVersion = "3.0.10";
in
stdenv.mkDerivation {
  pname = "sgx-ssl" + lib.optionalString debug "-debug";
  version = "${sgxVersion}_${opensslVersion}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-sgx-ssl";
    #rev = "lin_${sgxVersion}_${opensslVersion}";
    rev = "3.0_Rev2";
    hash = "sha256-dmLyaG6v+skjSa0KxLAfIfSBOxp9grrI7ds6WdGPe0I=";
  };

  postUnpack =
    let
      opensslSourceArchive = fetchurl {
        url = "https://www.openssl.org/source/openssl-${opensslVersion}.tar.gz";
        hash = "sha256-F2HU9bE6ECi5tvPUuOF/6wztyTcPav5h1xk9LNzoMyM=";
      };
    in
    ''
      ln -s ${opensslSourceArchive} $sourceRoot/openssl_source/openssl-${opensslVersion}.tar.gz
    '';

  postPatch = ''
    patchShebangs Linux/build_openssl.sh

    # Run the test in the `installCheckPhase`, not the `buildPhase`
    substituteInPlace Linux/sgx/Makefile \
      --replace '$(MAKE) -C $(TEST_DIR) all' \
                'bash -c "true"'
  '';

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
  doInstallCheck = true;
  installCheckTarget = "test";
  installCheckFlags = [
    "SGX_MODE=SIM"
    "-j 1" # Makefile doesn't support multiple jobs
  ];
  nativeInstallCheckInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Cryptographic library for Intel SGX enclave applications based on OpenSSL";
    homepage = "https://github.com/intel/intel-sgx-ssl";
    maintainers = with maintainers; [ trundle veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = [ licenses.bsd3 licenses.openssl ];
  };
}
