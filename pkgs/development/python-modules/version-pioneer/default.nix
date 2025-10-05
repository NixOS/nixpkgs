{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-requirements-txt,
  hatchling,
  tomli,
  docstring-parser,
  typer,
  typing-extensions,
  verboselogs,
  wheel,
}:

buildPythonPackage rec {
  pname = "version-pioneer";
  version = "0.0.13";
  pyproject = true;

  src = fetchPypi {
    pname = "version_pioneer";
    inherit version;
    hash = "sha256-bUocCPOtiHFNmf/GtU+szyLMomwYBziK7cPAY8Nki18=";
  };

  build-system = [
    hatch-requirements-txt
    hatchling
    tomli
  ];

  dependencies = [
    tomli
  ];

  optional-dependencies = {
    cli = [
      docstring-parser
      typer
      typing-extensions
      verboselogs
      wheel
    ];
  };

  pythonImportsCheck = [
    "version_pioneer"
  ];

  meta = {
    description = "VCS-based project version management for any build backend (setuptools, hatchling, pdm) extensible to any programming language";
    homepage = "https://pypi.org/project/version-pioneer/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DuarteSJ ];
  };
}
