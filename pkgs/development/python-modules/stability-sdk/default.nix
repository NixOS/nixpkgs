{ lib
, buildPythonPackage
, fetchFromGitHub

, pillow
, grpcio
, grpcio-tools
, python-dotenv
, param
, protobuf

, keyframed
, numpy
, opencv4

, pytestCheckHook
, grpcio-testing
}:

buildPythonPackage rec {
  pname = "stability-sdk";
  version = "0.8.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Stability-AI";
    repo = "stability-sdk";
    rev = "refs/tags/v${version}";
    hash = "sha256-b1hUGj+6ZBv896MVVfFhaM6Y6N1Bn0+bsu0p2jPurDY=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace setup.py \
          --replace "grpcio==1.53.0" "grpcio" \
          --replace "grpcio-tools==1.53.0" "grpcio-tools"
  '';

  propagatedBuildInputs = [
    pillow
    grpcio
    grpcio-tools
    python-dotenv
    param
    protobuf
  ];

  passthru.optional-dependencies = {
    anim = [
      keyframed
      numpy
      opencv4
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.anim;

  # Don't check tests in git submodules
  disabledTestPaths = [
    "src/stability_sdk/interfaces"
  ];

  pythonImportsCheck = [
    "stability_sdk"
  ];

  meta = {
    homepage = "https://stability.ai";
    description = "Python SDK for interacting with stability.ai APIs";
    changelog = "https://github.com/Stability-AI/stability-sdk/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
