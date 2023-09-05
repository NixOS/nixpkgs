{ lib
, buildPythonApplication
, fetchFromGitHub
, nixosTests
, pythonOlder
# dependencies
, aiohttp
, aiohttp-openmetrics
, defusedxml
, dulwich
, icalendar
, jinja2
, multidict
, vobject
# build dependencies
, setuptools
, wheel
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "xandikos";
  version = "0.2.10";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jelmer";
    repo = "xandikos";
    rev = "v${version}";
    sha256 = "sha256-SqU/K3b8OML3PvFmP7L5R3Ub9vbW66xRpf79mgFZPfc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    aiohttp-openmetrics
    dulwich
    defusedxml
    icalendar
    jinja2
    multidict
    vobject
  ];

  passthru.tests.xandikos = nixosTests.xandikos;

  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # these tests are failing due to the following error:
    # TypeError: index_entry_from_stat() missing 1 required positional argument
    "test_backend"
    "test_delete_one"
    "test_delete_one_invalid_etag"
    "test_delete_one_with_etag"
    "test_get_by_index"
    "test_get_file"
    "test_get_raw"
    "test_import_one"
    "test_import_one_duplicate_name"
    "test_import_one_duplicate_uid"
    "test_import_only_once"
    "test_with_filter"
  ];

  meta = with lib; {
    description = "Lightweight CalDAV/CardDAV server";
    homepage = "https://github.com/jelmer/xandikos";
    license = licenses.gpl3Plus;
    changelog = "https://github.com/jelmer/xandikos/blob/v${version}/NEWS";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
