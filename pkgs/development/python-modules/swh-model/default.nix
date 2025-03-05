{
  lib,
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
  pytest,
  pytz,
  types-click,
  types-python-dateutil,
  types-pytz,
  types-deprecated,

}:

buildPythonPackage rec {
  pname = "swh-model";
  version = "6.16.0";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-model";
    rev = "refs/tags/v${version}";
    hash = "sha256-N9t21eU544fSzpzOccOjZdxOtFezi/Cq7HQE8TLqYVw=";
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
    pytest
    pytz
    types-click
    types-python-dateutil
    types-pytz
    types-deprecated
  ];

  meta = {
    description = "Implementation of the Data model of the Software Heritage project, used to archive source code artifacts";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-model";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
