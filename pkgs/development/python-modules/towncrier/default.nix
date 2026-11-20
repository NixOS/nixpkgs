{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  git, # shells out to git
  hatchling,
  incremental,
  jinja2,
  mock,
  pytestCheckHook,
  twisted,
}:

buildPythonPackage rec {
  pname = "towncrier";
  version = "26.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rOkDFjHHGMwHCRB7h1Xm4xNQ64rNyHevQ98xd63bmlU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    incremental
    jinja2
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    git
    mock
    twisted
    pytestCheckHook
  ];

  pythonImportsCheck = [ "towncrier" ];

  meta = {
    description = "Utility to produce useful, summarised news files";
    homepage = "https://github.com/twisted/towncrier/";
    changelog = "https://github.com/twisted/towncrier/blob/${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "towncrier";
  };
}
