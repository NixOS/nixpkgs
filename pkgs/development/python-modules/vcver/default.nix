{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
}:

buildPythonPackage rec {
  pname = "vcver";
  version = "0.2.12";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "toumorokoshi";
    repo = "vcver-python";
    rev = "c5d8a6f1f0e49bb25f5dbb07312e42cb4da096d6";
    sha256 = "1cvgs70jf7ki78338zaglaw2dkvyndmx15ybd6k4zqwwsfgk490b";
  };

  propagatedBuildInputs = [ packaging ];

  # circular dependency on test tool uranium https://pypi.org/project/uranium/
  doCheck = false;

  pythonImportsCheck = [ "vcver" ];

  meta = with lib; {
    description = "Reference Implementation of vcver";
    homepage = "https://github.com/toumorokoshi/vcver-python";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
