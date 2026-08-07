{
  lib,
  stdenv,
  replaceVars,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  fetchpatch2,
  asn1crypto,
  cffi,
  cryptography,
  pkgconfig, # see nativeBuildInputs
  pkg-config, # see nativeBuildInputs
  pytestCheckHook,
  pyyaml,
  setuptools-scm,
  tpm2-tss,
  tpm2-tools,
  swtpm,
}:

let
  isCross = (stdenv.buildPlatform != stdenv.hostPlatform);
in
buildPythonPackage rec {
  pname = "tpm2-pytss";
  version = "3.0.0rc1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "tpm2_pytss";
    hash = "sha256-9Wj7RKjcjCzPqlsA4PxgVGQBvqQKuANG2tMb/cI3ihE=";
  };

  patches = [
  ]
  ++ lib.optionals isCross [
    # pytss will regenerate files from headers of tpm2-tss.
    # Those headers are fed through a compiler via pycparser. pycparser expects `cpp`
    # to be in the path.
    # This is put in the path via stdenv when not cross-compiling, but this is absent
    # when cross-compiling is turned on.
    # This patch changes the call to pycparser.preprocess_file to provide the name
    # of the cross-compiling cpp
    # NOTE: This patch could be dropped after next release. 3.0.0-rc0 already have proper `$CC -E` invocation
    (replaceVars ./cross.patch {
      crossPrefix = stdenv.hostPlatform.config;
    })
  ];

  # Hardening has to be disabled
  # due to pycparsing handling it poorly.
  # See https://github.com/NixOS/nixpkgs/issues/252023
  # for more details.
  hardeningDisable = [ "fortify" ];

  nativeBuildInputs = [
    cffi
    pkgconfig # this is the Python module
    pkg-config # this is the actual pkg-config tool
    setuptools-scm
  ];

  buildInputs = [ tpm2-tss ];

  propagatedBuildInputs = [
    cffi
    asn1crypto
    cryptography
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tpm2-tools
    swtpm
  ];

  preCheck = ''
    export TSS2_FAPICONF=${tpm2-tss.out}/etc/tpm2-tss/fapi-config-test.json
  '';

  pythonImportsCheck = [ "tpm2_pytss" ];

  meta = {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    changelog = "https://github.com/tpm2-software/tpm2-pytss/blob/${version}/CHANGELOG.md";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      baloo
      scottstephens
    ];
  };
}
