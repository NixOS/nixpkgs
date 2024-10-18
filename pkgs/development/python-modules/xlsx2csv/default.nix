{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "xlsx2csv";
  version = "0.8.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bGXVmJ6NPxTdcpbUJdaTpn9RiZ0Mjh7XvL+cyxgiNzQ=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  meta = with lib; {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    mainProgram = "xlsx2csv";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jb55 ];
  };
}
