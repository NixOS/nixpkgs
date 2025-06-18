{
  lib,
  buildPythonPackage,
  fetchPypi,
  python3Packages,
  ...
}:

buildPythonPackage rec {
  pname = "isobiscuit";
  version = "0.3.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03ivhmh9ikc51mi2547m0my2fvgicgnnc40lqjgc8g276imfhq13";
  };

  format = "pyproject";

  nativeBuildInputs = with python3Packages; [
    poetry-core
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    requests
    pyyaml
    colorama
  ];

  meta = with lib; {
    description = "IsoBiscuit is a tool for virtualization, where processes are running in biscuits.";
    homepage = "https://github.com/isobiscuit/isobiscuit";
    license = licenses.asl20;
    maintainers = with maintainers; [ trollmii ];
  };
}
