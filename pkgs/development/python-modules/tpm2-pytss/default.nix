{
  lib,
  stdenv,
  replaceVars,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
  fetchpatch2,
  pythonOlder,
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
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IAcRKTeWVvXzw7wW02RhJnKxR9gRkftOufn/n77khBA=";
  };

  patches = [
    # libtpms (underneath swtpm) bumped the TPM revision
    # https://github.com/tpm2-software/tpm2-pytss/pull/593
    (fetchpatch {
      url = "https://github.com/tpm2-software/tpm2-pytss/pull/593.patch";
      hash = "sha256-CNJnSIvUQ0Yvy0o7GdVfFZ7kHJd2hBt5Zv1lqgOeoks=";
    })
    # support cryptography >= 45.0.0
    # https://github.com/tpm2-software/tpm2-pytss/pull/643
    (fetchpatch {
      url = "https://github.com/tpm2-software/tpm2-pytss/commit/6ab4c74e6fb3da7cd38e97c1f8e92532312f8439.patch";
      hash = "sha256-01Qe4qpD2IINc5Z120iVdPitiLBwdr8KNBjLFnGgE7E=";
    })
    # Properly restore environment variables upon exit from
    # FAPIConfig context. Accepted into upstream, not yet released.
    (fetchpatch2 {
      url = "https://github.com/tpm2-software/tpm2-pytss/commit/afdee627d0639eb05711a2191f2f76e460793da9.patch?full_index=1";
      hash = "sha256-Y6drcBg4gnbSvnCGw69b42Q/QfLI3u56BGRUEkpdB0M=";
    })
  ]
  ++ lib.optionals isCross [
    # pytss will regenerate files from headers of tpm2-tss.
    # Those headers are fed through a compiler via pycparser. pycparser expects `cpp`
    # to be in the path.
    # This is put in the path via stdenv when not cross-compiling, but this is absent
    # when cross-compiling is turned on.
    # This patch changes the call to pycparser.preprocess_file to provide the name
    # of the cross-compiling cpp
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

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    changelog = "https://github.com/tpm2-software/tpm2-pytss/blob/${version}/CHANGELOG.md";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      baloo
      scottstephens
    ];
  };
}
