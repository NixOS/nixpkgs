{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "types-pyyaml";
  version = "6.0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "types-PyYAML";
    inherit version;
    sha256 = "sha256-M651yEuPYf3fDGPpx+VX252xaUrTwu6GKOxe/rtaXps=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "yaml-stubs"
  ];

  meta = with lib; {
    description = "Typing stubs for PyYAML";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ dnr ];
  };
}
