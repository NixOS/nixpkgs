{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitLab,
  setuptools,
  setuptools-scm,
  attrs,
  attrs-strict,
  dateutils,
  deprecated,
  hypothesis,
  iso8601,
  typing-extensions,
  click,
  dulwich,
  aiohttp,
  pytestCheckHook,
  pytz,
  types-click,
  types-python-dateutil,
  types-pytz,
  types-deprecated,

}:

buildPythonPackage rec {
  pname = "swh-model";
  version = "8.4.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-model";
    tag = "v${version}";
    hash = "sha256-v/vbY0mxvsbuLUAmDACW9brfVF5djMYyvv9Mf1VL6do=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    attrs-strict
    click
    dulwich
    dateutils
    deprecated
    hypothesis
    iso8601
    typing-extensions
  ];

  pythonImportsCheck = [ "swh.model" ];

  nativeCheckInputs = [
    aiohttp
    click
    pytestCheckHook
    pytz
    types-click
    types-python-dateutil
    types-pytz
    types-deprecated
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin) [
    # OSError: [Errno 92] Illegal byte sequence
    "swh/model/tests/test_cli.py::TestIdentify::test_exclude"
    "swh/model/tests/test_from_disk.py::DirectoryToObjects::test_exclude"
    "swh/model/tests/test_from_disk.py::DirectoryToObjects::test_exclude_trailing"
  ];

  meta = {
    description = "Implementation of the Data model of the Software Heritage project, used to archive source code artifacts";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-model";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
  };
}
