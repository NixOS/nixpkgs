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
  version = "6.7.12";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-COZvdCWS64GKyP2kFz4u1kyfLUC3C+4R2xxJkSfZhFA=";
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
