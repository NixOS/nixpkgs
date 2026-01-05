{
  lib,
  buildPythonApplication,
  fetchPypi,
  setuptools,
}:

buildPythonApplication rec {
  pname = "pyznap";
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "88bf1d6de2c11f14acbdfa01b61eb95c94f95d829ddebdaee3786b64ccb93ae3";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  # tests aren't included in the PyPI packages
  doCheck = false;

  meta = {
    homepage = "https://github.com/yboetz/pyznap";
    description = "ZFS snapshot tool written in python";
    mainProgram = "pyznap";
    license = with lib.licenses; [ gpl3 ];
    maintainers = with lib.maintainers; [ rbrewer ];
  };
}
