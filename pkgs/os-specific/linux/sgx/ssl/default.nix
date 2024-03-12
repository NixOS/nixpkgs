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
  opensslVersion = "1.1.1u";
in
stdenv.mkDerivation {
  pname = "sgx-ssl" + lib.optionalString debug "-debug";
  version = "${sgxVersion}_${opensslVersion}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-sgx-ssl";
    rev = "lin_${sgxVersion}_${opensslVersion}";
    hash = "sha256-zbXEQz72VUPqnGrboX6oXliaLpbcos7tV6K9lX+zleg=";
  };

  postUnpack =
    let
      opensslSourceArchive = fetchurl {
        url = "https://www.openssl.org/source/openssl-${opensslVersion}.tar.gz";
        hash = "sha256-4vjYS1I+7NBse+diaDA3AwD7zBU4a/UULXJ1j2lj68Y=";
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
