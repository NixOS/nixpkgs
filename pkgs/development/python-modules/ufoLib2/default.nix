{ lib
, buildPythonPackage
, fetchPypi
, attrs
, fonttools
, pytestCheckHook
, fs
}:

buildPythonPackage rec {
  pname = "ufoLib2";
  version = "0.13.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "xJfvyNE+30BgNirX8u1xhKcD8pM3owRAVC4WX+qFqEM=";
  };

  propagatedBuildInputs = [
    attrs
    fonttools
    # required by fonttools[ufo]
    fs
  ];

  checkInputs = [
    pytestCheckHook
  ];

pythonImportsCheck = [ "ufoLib2" ];

  meta = with lib; {
    description = "Library to deal with UFO font sources";
    homepage = "https://github.com/fonttools/ufoLib2";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
  };
}
