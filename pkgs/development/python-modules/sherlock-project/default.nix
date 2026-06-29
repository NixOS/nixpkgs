{
  lib,
  buildPythonPackage,
  certifi,
  colorama,
  fetchFromGitHub,
  jsonschema,
  nix-update-script,
  openpyxl,
  pandas,
  poetry-core,
  pysocks,
  pytestCheckHook,
  requests-futures,
  requests,
  rstr,
  stem,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "sherlock-project";
  version = "0.16.0-unstable-2026-05-09";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sherlock-project";
    repo = "sherlock";
    rev = "206068dc7842665130c87e16e1535572d3d1a907";
    hash = "sha256-QM0vHvZ1w9FtM0bGPGvMhhobPKOGQNPacVWB0caoPTw=";
  };

  postPatch = ''
    substituteInPlace sherlock_project/__init__.py \
      --replace-fail "__version__     = get_version()" "__version__ = \"${finalAttrs.version}\""
  '';

  build-system = [ poetry-core ];

  dependencies = [
    certifi
    colorama
    openpyxl
    pandas
    pysocks
    requests
    requests-futures
    stem
    tomli
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
    rstr
  ];

  disabledTestMarks = [
    # Tests require internet access
    "online"
  ];

  pythonImportsCheck = [ "sherlock_project" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hunt down social media accounts by username across social networks";
    homepage = "https://github.com/sherlock-project/sherlock";
    changelog = "https://github.com/sherlock-project/sherlock/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ applePrincess ];
    mainProgram = "sherlock";
  };
})
