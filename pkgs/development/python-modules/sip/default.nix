{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, wheel
, packaging
, ply
, toml
, tomli
}:

buildPythonPackage rec {
  pname = "sip";
  version = "6.8.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MALfQV4WisP/45OULbxxMcuCreUAAOFSb0aoit4m9Zg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [ packaging ply toml ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  # There aren't tests
  doCheck = false;

  pythonImportsCheck = [ "sipbuild" ];

  meta = with lib; {
    description = "Creates C++ bindings for Python modules";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    maintainers = with maintainers; [ nrdxp ];
  };
}
