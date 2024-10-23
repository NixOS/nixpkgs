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
}:

buildPythonPackage rec {
  pname = "swh-model";
  version = "6.13.1";
  pyproject = true;

  src = fetchFromGitLab {
    domain = "gitlab.softwareheritage.org";
    group = "swh";
    owner = "devel";
    repo = "swh-model";
    rev = "v${version}";
    hash = "sha256-D0F8rPStCF5MwUOxATVL+r3ZSEHUAZ1BhevILuQfn84=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    attrs-strict
    dateutils
    deprecated
    hypothesis
    iso8601
    typing-extensions
  ];

  passthru.optional-dependencies = {
    cli = [
      click
      dulwich
    ];
  };

  pythonImportsCheck = [ "swh.model" ];

  meta = {
    description = "Implementation of the Data model of the Software Heritage project, used to archive source code artifacts";
    homepage = "https://gitlab.softwareheritage.org/swh/devel/swh-model";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
