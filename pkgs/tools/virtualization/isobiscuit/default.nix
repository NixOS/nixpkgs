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

  propagatedBuildInputs = with python3Packages; [
    requests
    pyyaml
    colorama
    poetry-core
  ];

  meta = with lib; {
    description = "IsoBiscuit is a tool for virtualization, where processes are running in biscuits.";
    license = licenses.asl20;
    maintainers = with maintainers; [ trollmii ];
  };
}
