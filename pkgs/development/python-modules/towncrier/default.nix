{ lib, buildPythonPackage, fetchPypi, isPy27
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
  version = "21.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6eed0bc924d72c98c000cb8a64de3bd566e5cb0d11032b73fcccf8a8f956ddfe";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    incremental
    jinja2
    toml
    setuptools
  ];

  # zope.interface collision
  doCheck = !isPy27;
  checkInputs = [
    git
    mock
    twisted
    pytestCheckHook
  ];
  pythonImportsCheck = [ "towncrier" ];

  meta = with lib; {
    description = "Utility to produce useful, summarised news files";
    homepage = "https://github.com/twisted/towncrier/";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
  };
}
