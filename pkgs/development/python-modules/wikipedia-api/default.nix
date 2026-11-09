{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  httpx,
  pytest-asyncio,
  pytest-recording,
  pytestCheckHook,
  respx,
  tenacity,
}:

buildPythonPackage rec {
  pname = "wikipedia-api";
  version = "0.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "martin-majlis";
    repo = "Wikipedia-API";
    tag = "v${version}";
    hash = "sha256-UpRC/Itt//lFhXXtxAlzpqKwj54TZ8MSNm6pYnpyzzU=";
  };

  build-system = [ hatchling ];

  preConfigure = ''
    make process-readme
  '';

  pythonRelaxDeps = true;

  dependencies = [
    click
    httpx
    tenacity
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-recording
    pytestCheckHook
    respx
  ];

  disabledTests = [
    # wikipediaapi.exceptions.wiki_connection_error.WikiConnectionError: https://en.wikipedia.org/w/api.php
    "test_search_with_enum_parameters"
    "test_search_with_mixed_parameters"
    "test_search_with_string_parameters"
  ];

  pythonImportsCheck = [ "wikipediaapi" ];

  meta = {
    description = "Python wrapper for Wikipedia";
    homepage = "https://github.com/martin-majlis/Wikipedia-API";
    changelog = "https://github.com/martin-majlis/Wikipedia-API/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
