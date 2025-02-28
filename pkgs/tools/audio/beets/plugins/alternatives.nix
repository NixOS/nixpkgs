{
  lib,
  fetchFromGitHub,
  beets,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    tag = "v${version}";
    hash = "sha256-+LvQC7hYtbJeWJiDEKtSFZaEtnuXZ+4mI75rrX9Sd64=";
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
      typeguard
    ]
    ++ [
      writableTmpDirAsHomeHook
    ];

  disabledTests = [
    # ValueError: too many values to unpack (expected 2)
    # https://github.com/geigerzaehler/beets-alternatives/issues/122
    "test_embed_art"
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
