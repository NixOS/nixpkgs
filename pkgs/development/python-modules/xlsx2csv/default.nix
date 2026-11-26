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
  version = "0.8.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8QndlVZeAVz49DD0o3/TcfT/s4qVaj+Wm8PVMlWTr94=";
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
