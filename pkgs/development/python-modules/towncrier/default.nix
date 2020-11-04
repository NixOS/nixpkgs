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
  version = "19.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "15l1gb0hhi9pf3mhhb9vpc93w6w3hrih2ljmzbkgfb3dwqd1l9a8";
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
