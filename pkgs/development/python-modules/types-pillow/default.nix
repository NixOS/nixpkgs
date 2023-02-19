{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "9.4.0.12";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    sha256 = "sha256-4AdBSdXwbTWTwRisyD41P4VCvMc1dv/vtlaOqrVnE0g=";
  };

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "PIL-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for Pillow";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ arjan-s ];
  };
}
