{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  boilerpy3,
  cdxj-indexer,
  frictionless,
  jsonlines,
  pytest-cov,
  pyyaml,
  shortuuid,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wacz";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "py-wacz";
    tag = "v${version}";
    hash = "sha256-bGY6G7qBAN1Vu+pTNqRG0xh34sR62pMhQFHFGlJaTPQ=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  # Upstream appears to attempt to pin transitive dependencies (typer, click)
  # to work around package conflicts.
  dependencies = [
    boilerpy3
    cdxj-indexer
    frictionless
    pytest-cov
    pyyaml
    shortuuid
  ];

  optional-dependencies = {
    # signing = [
    #   authsign # not packaged
    # ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    jsonlines # Not even actually used...
  ];

  disabledTests = [
    # authsign is not packaged
    "test_verify_signed"
  ];

  pythonImportsCheck = [
    "wacz"
  ];

  meta = {
    description = "Utility for working with web archive data using the WACZ format specification";
    homepage = "https://github.com/webrecorder/py-wacz";
    changelog = "https://github.com/webrecorder/py-wacz/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
    mainProgram = "wacz";
  };
}
