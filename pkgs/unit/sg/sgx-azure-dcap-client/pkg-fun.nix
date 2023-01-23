{ stdenv
, fetchFromGitHub
, fetchurl
, lib
, curl
, nlohmann_json
, openssl
, pkg-config
, linkFarmFromDrvs
, callPackage
}:

let
  # Although those headers are also included in the source of `sgx-psw`, the `azure-dcap-client` build needs specific versions
  filterSparse = list: ''
    cp -r "$out"/. .
    find "$out" -mindepth 1 -delete
    cp ${lib.concatStringsSep " " list} "$out/"
  '';
  headers = linkFarmFromDrvs "azure-dcpa-client-intel-headers" [
    (fetchFromGitHub rec {
      name = "${repo}-headers";
      owner = "intel";
      repo = "SGXDataCenterAttestationPrimitives";
      rev = "0436284f12f1bd5da7e7a06f6274d36b4c8d39f9";
      sparseCheckout = [ "QuoteGeneration/quote_wrapper/common/inc/sgx_ql_lib_common.h" ];
      hash = "sha256-ipKpYHbiwjCUXF/pCArJZy5ko1YX2wqMMdSnMUzhkgY=";
      postFetch = filterSparse sparseCheckout;
    })
    (fetchFromGitHub rec {
      name = "${repo}-headers";
      owner = "intel";
      repo = "linux-sgx";
      rev = "1ccf25b64abd1c2eff05ead9d14b410b3c9ae7be";
      hash = "sha256-WJRoS6+NBVJrFmHABEEDpDhW+zbWFUl65AycCkRavfs=";
      sparseCheckout = [
        "common/inc/sgx_report.h"
        "common/inc/sgx_key.h"
        "common/inc/sgx_attributes.h"
      ];
      postFetch = filterSparse sparseCheckout;
    })
  ];
in
stdenv.mkDerivation rec {
  pname = "azure-dcap-client";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = version;
    hash = "sha256-EYj3jnzTyJRl6N7avNf9VrB8r9U6zIE6wBNeVsMtWCA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    curl
    nlohmann_json
    openssl
  ];

  postPatch = ''
    mkdir -p src/Linux/ext/intel
    find -L '${headers}' -type f -exec ln -s {} src/Linux/ext/intel \;

    substitute src/Linux/Makefile{.in,} \
      --replace '##CURLINC##' '${curl.dev}/include/curl/' \
      --replace '$(TEST_SUITE): $(PROVIDER_LIB) $(TEST_SUITE_OBJ)' '$(TEST_SUITE): $(TEST_SUITE_OBJ)'
  '';

  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  makeFlags = [
    "-C src/Linux"
    "prefix=$(out)"
  ];

  # Online test suite; run with
  # $(nix-build -A sgx-azure-dcap-client.tests.suite)/bin/tests
  passthru.tests.suite = callPackage ./test-suite.nix { };

  meta = with lib; {
    description = "Interfaces between SGX SDKs and the Azure Attestation SGX Certification Cache";
    homepage = "https://github.com/microsoft/azure-dcap-client";
    maintainers = with maintainers; [ trundle veehaitch ];
    platforms = [ "x86_64-linux" ];
    license = [ licenses.mit ];
  };
}
