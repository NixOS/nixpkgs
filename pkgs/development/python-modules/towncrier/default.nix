{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, click-default-group
, incremental
, jinja2
, mock
, pytestCheckHook
, toml
, twisted
, git # shells out to git
}:

buildPythonPackage rec {
  pname = "towncrier";
  version = "21.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nLb0XBbhoe7J0OdlEWXnvmDNCrgdE6XJbKl6SYrof0g=";
  };

  propagatedBuildInputs = [
    click
    click-default-group
    incremental
    jinja2
    toml
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
