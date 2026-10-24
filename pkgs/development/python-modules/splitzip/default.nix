{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  versionCheckHook,
  which,
  mypy,
  pytest,
  pytest-cov,
  ruff,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "splitzip";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "twwat";
    repo = "splitzip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OwC31MyTuHAcGX81WYnUKVNa6nKQKmr7M8Vlx2jkzCE=";
  };

  build-system = [
    hatchling
  ];


  postPatch = ''
    # See upstream issue https://github.com/twwat/splitzip/issues/1
    sed -i 's/^__version__ = .*$/__version__ = __import__("importlib.metadata", globals(), locals()).metadata.version("splitzip")/' src/splitzip/__init__.py
  '';

  pythonImportsCheck = [
    "splitzip"
  ];

  nativeInstallCheckInputs = [
    pytestCheckHook
    versionCheckHook
    which
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Pure Python library/utility to create split ZIP archives compatible with Windows Explorer, 7-Zip, and standard unzip";
    homepage = "https://github.com/twwat/splitzip";
    changelog = "https://github.com/twwat/splitzip/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      ShamrockLee
    ];
    mainProgram = "splitzip";
  };
})
