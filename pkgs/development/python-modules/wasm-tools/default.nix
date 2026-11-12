{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # tests
  jq,
  pytest-cov-stub,
  pytestCheckHook,
  runtimeShell,
}:

buildPythonPackage (finalAttrs: {
  pname = "wasm-tools";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "appthreat";
    repo = "wasm-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AwpQ5jCg6C7opBLaL6GU3Ve2iiwxkNl6CpL6oS3osfU=";
  };

  postPatch = ''
    substituteInPlace tests/test_docs.py \
      --replace-fail '#!/usr/bin/env bash' '#!${runtimeShell}'
  '';

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "wasm_tools"
  ];

  nativeCheckInputs = [
    jq
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "WebAssembly parser and disassembler in python";
    homepage = "https://github.com/appthreat/wasm-tools";
    changelog = "https://github.com/appthreat/wasm-tools/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "wasm-tools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
