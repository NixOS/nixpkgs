{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyarrow,
  pytz,
  textual,
  tzdata,
  pythonOlder,
  polars,
  pytest-asyncio,
  pytest-textual-snapshot,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "textual-fastdatatable";
  version = "0.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "tconbeer";
    repo = "textual-fastdatatable";
    tag = "v${version}";
    hash = "sha256-aQduVFHsdAMwjJzFPqOGB5Ec16YZ9YOYnEK6Ilf96xM=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyarrow
    pytz
    textual
    tzdata
  ]
  ++ textual.optional-dependencies.syntax;

  optional-dependencies = {
    polars = [ polars ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-textual-snapshot
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "textual_fastdatatable" ];

  disabledTestPaths = [
    # Tests are comparing CLI output
    "tests/snapshot_tests/test_snapshots.py"
  ];

  meta = {
    description = "Performance-focused reimplementation of Textual's DataTable widget, with a pluggable data storage backend";
    homepage = "https://github.com/tconbeer/textual-fastdatatable";
    changelog = "https://github.com/tconbeer/textual-fastdatatable/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pcboy ];
  };
}
