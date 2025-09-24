{
  lib,
  fetchFromGitHub,
  beets,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "0.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    tag = "v${version}";
    hash = "sha256-j56AzbpZFACXy5KqafE8PCC+zM6pXrxr/rWy9UjZPQg=";
  };

  nativeBuildInputs = [
    beets
  ];

  dependencies = [
    python3Packages.poetry-core
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      pytestCheckHook
      pytest-cov-stub
      mock
      pillow
      typeguard
    ]
    ++ [
      writableTmpDirAsHomeHook
    ];

  meta = {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    changelog = "https://github.com/geigerzaehler/beets-alternatives/blob/v${version}/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      aszlig
      lovesegfault
    ];
    license = lib.licenses.mit;
  };
}
