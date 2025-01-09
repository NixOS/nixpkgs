{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytestCheckHook,
  runCommand,

  setuptools,
  unicodeit,
}:
buildPythonPackage rec {
  pname = "unicodeit";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "svenkreiss";
    repo = "unicodeit";
    tag = "v${version}";
    hash = "sha256-NeR3fGDbOzwyq85Sep9KuUiARCvefN6l5xcb8D/ntHE=";
  };

  patches = [
    (fetchpatch {
      # Defines a CLI entry point, so `setuptools` generates an `unicodeit` executable
      url = "https://github.com/svenkreiss/unicodeit/pull/79/commits/9f4a4fee5cb62a101075adf3054832cdb1e6a5ad.patch";
      hash = "sha256-mAhmU17K0adEFFAIf7ZeJ/cNohrzrL+sol7gYfWbPGo=";
    })
  ];

  build-system = [ setuptools ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "unicodeit"
    "unicodeit.cli"
  ];

  passthru.tests.entrypoint =
    runCommand "python3-unicodeit-test-entrypoint"
      {
        nativeBuildInputs = [ unicodeit ];
        preferLocalBuild = true;
      }
      ''
        [[ "$(unicodeit "\BbbR")" = "ℝ" ]]
        touch $out
      '';

  meta = {
    description = "Converts LaTeX tags to unicode";
    mainProgram = "unicodeit";
    homepage = "https://github.com/svenkreiss/unicodeit";
    license = with lib.licenses; [
      lppl13c
      mit
    ];
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
