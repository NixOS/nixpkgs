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
  version = "0.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YY/FAmEoYN6KuOPWGV6Z7zMv/8aDN/a4nllpCq0NILU=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  meta = {
    homepage = "https://github.com/dilshod/xlsx2csv";
    description = "Convert xlsx to csv";
    mainProgram = "xlsx2csv";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jb55 ];
  };
}
