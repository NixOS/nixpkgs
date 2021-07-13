{ lib, buildPythonPackage, fetchPypi, isPy27
, click
, click-default-group
, incremental
, jinja2
, pytestCheckHook
, toml
, twisted
, git # shells out to git
}:

buildPythonPackage rec {
  pname = "towncrier";
  version = "19.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19916889879353a8863f3de8cb1ef19b305a0b5cfd9d36159d76ca2fef08e9aa";
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
  checkInputs = [ git twisted pytestCheckHook ];
  pythonImportsCheck = [ "towncrier" ];

  meta = with lib; {
    description = "Utility to produce useful, summarised news files";
    homepage = "https://github.com/twisted/towncrier/";
    license = licenses.mit;
    maintainers = with maintainers; [  ];
  };
}
