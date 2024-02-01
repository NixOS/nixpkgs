{ stdenv
, callPackage
, fetchFromGitHub
, fetchurl
, lib
, perl
, sgx-sdk
, which
, debug ? false
}:
let
  sgxVersion = sgx-sdk.versionTag;
  opensslVersion = "3.0.12";
in
stdenv.mkDerivation {
  pname = "sgx-ssl" + lib.optionalString debug "-debug";
  version = "${sgxVersion}_${opensslVersion}";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-sgx-ssl";
    rev = "3.0_Rev2";
    hash = "sha256-dmLyaG6v+skjSa0KxLAfIfSBOxp9grrI7ds6WdGPe0I=";
  };

  postUnpack =
    let
      opensslSourceArchive = fetchurl {
        url = "https://www.openssl.org/source/openssl-${opensslVersion}.tar.gz";
        hash = "sha256-+Tyejt3l6RZhGd4xdV/Ie0qjSGNmL2fd/LoU0La2m2E=";
      };
    in
    ''
      ln -s ${opensslSourceArchive} $sourceRoot/openssl_source/openssl-${opensslVersion}.tar.gz
    '';

  postPatch = ''
    patchShebangs Linux/build_openssl.sh

    # Skip the tests. Build and run separately (see below).
    substituteInPlace Linux/sgx/Makefile \
      --replace '$(MAKE) -C $(TEST_DIR) all' \
                'bash -c "true"'
  '';

  nativeBuildInputs = [
    perl
    sgx-sdk
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

  # These tests build on any x86_64-linux but BOTH SIM and HW will only _run_ on
  # real Intel hardware. Split these out so OfBorg doesn't choke on this pkg.
  #
  # ```
  # nix run .#sgx-ssl.tests.HW
  # nix run .#sgx-ssl.tests.SIM
  # ```
  passthru.tests = {
    HW = callPackage ./tests.nix { sgxMode = "HW"; inherit opensslVersion; };
    SIM = callPackage ./tests.nix { sgxMode = "SIM"; inherit opensslVersion; };
  };

  meta = with lib; {
    description = "Cryptographic library for Intel SGX enclave applications based on OpenSSL";
    homepage = "https://github.com/intel/intel-sgx-ssl";
    maintainers = with maintainers; [ phlip9 trundle veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = [ licenses.bsd3 licenses.openssl ];
  };
}
