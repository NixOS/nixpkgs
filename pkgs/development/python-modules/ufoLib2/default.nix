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
  version = "0.13.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MnWi2mI+bUt+4pyYTNs6W4a7wj8KHOlEhti7XDCKpHs=";
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
