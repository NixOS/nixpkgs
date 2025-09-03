{
  lib,
  stdenv,
  replaceVars,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,
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
    # Fix hardcoded `fapi-config.json` configuration path
    ./fapi-config.patch
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

  postPatch = ''
    sed -i "s#@TPM2_TSS@#${tpm2-tss.out}#" src/tpm2_pytss/FAPI.py
  '';

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

  pythonImportsCheck = [ "tpm2_pytss" ];

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    changelog = "https://github.com/tpm2-software/tpm2-pytss/blob/${version}/CHANGELOG.md";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
  };
}
