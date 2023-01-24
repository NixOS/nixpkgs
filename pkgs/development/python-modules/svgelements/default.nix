{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-xdist
, pillow
, scipy
}:

buildPythonPackage rec {
  pname = "svgelements";
  version = "1.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ic4y8YjXlo2gf1hdiBQcDNhjgEmmiBPWnH65QfoJ+tY=";
  };

  propagatedBuildInputs = [ ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    # https://github.com/meerk40t/svgelements#requirements
    pillow
    scipy
  ];

  pythonImportsCheck = [ "svgelements" ];

  meta = with lib; {
    description = "Svg Elements Parsing";
    homepage = "https://github.com/meerk40t/svgelements";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
