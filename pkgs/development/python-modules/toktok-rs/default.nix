{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
  nix-update-script,

  # optional-dependencies
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "toktok-rs";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "toktok";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eMy81qUraECQIgkL0h1msJ39/EHJnkMgGPfc2IFhZUs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-N6dunFUwDgTIk8ecvaBv+HR1tQo0bZUn9bJz2ht360c=";
  };

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  optional-dependencies = {
    numpy = [ numpy ];
  };

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Compares against tiktoken, which downloads its BPE files at runtime
    "tests/test_parity.py"
  ];

  disabledTests = [
    # Timing-based (CPU/wall ratio); flaky on shared builders
    "test_counting_actually_runs_in_parallel"
  ];

  pythonImportsCheck = [ "toktok" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast, exact BPE tokenizer for OpenAI encodings, with a Rust core";
    longDescription = ''
      toktok is a Rust port of quicktok, producing token ids identical to
      OpenAI's tiktoken for the cl100k, o200k and o200k_harmony encodings,
      with the vocabulary tables compiled into the extension module so
      nothing is downloaded at import time.
    '';
    homepage = "https://github.com/vectorize-io/toktok";
    changelog = "https://github.com/vectorize-io/toktok/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brudel ];
  };
})
