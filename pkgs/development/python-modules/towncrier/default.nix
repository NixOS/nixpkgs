{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, click
, click-default-group
, incremental
, jinja2
, mock
, pytestCheckHook
, toml
, twisted
, setuptools
, git # shells out to git
}:

buildPythonPackage rec {
  pname = "towncrier";
  version = "23.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/Cm9WrRyfI2s++Y29/tdxTuZgFti2hyWshSDYVn/cME=";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    incremental
    jinja2
    toml
    setuptools
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

  pythonImportsCheck = [
    "towncrier"
  ];

  meta = with lib; {
    description = "Utility to produce useful, summarised news files";
    homepage = "https://github.com/twisted/towncrier/";
    changelog = "https://github.com/twisted/towncrier/blob/${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
