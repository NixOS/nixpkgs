{
  lib,
  beets,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "beets-yearfixer";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adamjakab";
    repo = "BeetsPluginYearFixer";
    tag = "v${version}";
    hash = "sha256-TDRkCihp+hB33e9LCBpUye+KobpTPrDMutMa4zHJQ68=";
  };

  nativeBuildInputs = [
    beets
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    requests
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pytestCheckHook
    six
  ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Beets plugin for obsessive-compulsive music geeks to fix missing album release date";
    homepage = "https://github.com/adamjakab/BeetsPluginYearFixer";
    maintainers = with lib.maintainers; [ bandithedoge ];
    license = lib.licenses.mit;
    inherit (beets.meta) platforms;
  };
}
