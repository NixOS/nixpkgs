{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pillow";
  version = "9.4.0.13";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "types-Pillow";
    sha256 = "sha256-RRCqmKKJR79j8rKe3rvRG3z/hkfZC4Z87Js2dMCowyE=";
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
