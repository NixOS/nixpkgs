{ lib
, buildPythonPackage
, fetchPypi
, attrs
, fonttools
, pytestCheckHook
, fs
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "ufoLib2";
  version = "0.14.0";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OdUJfNe3nOQyCf3nT9/5y/C8vZXnSAWiLHvZ8GXMViw=";
  };

  propagatedBuildInputs = [
    attrs
    fonttools
    # required by fonttools[ufo]
    fs
  ];

  nativeBuildInputs = [ setuptools-scm ];

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
