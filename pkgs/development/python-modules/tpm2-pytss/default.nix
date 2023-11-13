{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder
, asn1crypto
, cffi
, cryptography
, pkgconfig # see nativeBuildInputs
, pkg-config # see nativeBuildInputs
, pycparser
, pytestCheckHook
, python
, pyyaml
, setuptools-scm
, tpm2-tss
, tpm2-tools
, swtpm
}:

buildPythonPackage rec {
  pname = "tpm2-pytss";
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-W1tLFFb9wa7vPSw5cL6qB4yPfyZIyXppvPYMWi+VyJc=";
  };

  patches = [
    # This patches the call to the C preprocessor not to include types
    # pycparser does not handle.
    # `hardeningDisable = [ "fortify" ]` would have the same effect but
    # would also disable hardening from generated FFI objects.
    #
    # backport of https://github.com/tpm2-software/tpm2-pytss/pull/523
    (fetchpatch {
      url = "https://github.com/baloo/tpm2-pytss/commit/099c069f28cfcd0a3019adebfeafa976f9395221.patch";
      sha256 = "sha256-wU2WfLYFDmkhGzYornZ386tB3zb3GYfGOTc+/QOFb1o=";
    })

    # Lookup tcti via getinfo not system's ld_library_path
    # https://github.com/tpm2-software/tpm2-pytss/pull/525
    (fetchpatch {
      url = "https://github.com/tpm2-software/tpm2-pytss/commit/97289a08ddf44f7bdccdd122d6055c69e12dc584.patch";
      sha256 = "sha256-VFq3Hv4I8U8ifP/aSjyu0BiW/4jfPlRDKqRcqUGw6UQ=";
    })

    (fetchpatch {
      name = "test-new-cryptography.patch";
      url = "https://github.com/tpm2-software/tpm2-pytss/commit/e4006e6066c015d9ed55befa9b98247fbdcafd7d.diff";
      sha256 = "sha256-Wxe9u7Cvv2vKMGTcK3X8W1Mq/nCt70zrzWUKA+83Sas=";
    })

    # Fix hardcoded `fapi-config.json` configuration path
    ./fapi-config.patch
  ];

  postPatch = ''
    sed -i "s#@TPM2_TSS@#${tpm2-tss.out}#" src/tpm2_pytss/FAPI.py
  '';

  # Hardening has to be disabled
  # due to pycparsing handling it poorly.
  # See https://github.com/NixOS/nixpkgs/issues/252023
  # for more details.
  hardeningDisable = [
    "fortify"
  ];

  nativeBuildInputs = [
    cffi
    pkgconfig # this is the Python module
    pkg-config # this is the actual pkg-config tool
    setuptools-scm
  ];

  buildInputs = [
    tpm2-tss
  ];

  propagatedBuildInputs = [
    cffi
    asn1crypto
    cryptography
    pyyaml
  ];

  doCheck = true;

  nativeCheckInputs = [
    pytestCheckHook
    tpm2-tools
    swtpm
  ];

  pythonImportsCheck = [
    "tpm2_pytss"
  ];

  meta = with lib; {
    homepage = "https://github.com/tpm2-software/tpm2-pytss";
    changelog = "https://github.com/tpm2-software/tpm2-pytss/blob/${version}/CHANGELOG.md";
    description = "TPM2 TSS Python bindings for Enhanced System API (ESYS)";
    license = licenses.bsd2;
    maintainers = with maintainers; [ baloo ];
  };
}
