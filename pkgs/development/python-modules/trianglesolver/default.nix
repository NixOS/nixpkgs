{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "trianglesolver";
  version = "1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SvGKreV51cDWQ4mz5lrq8Gz/JjGXYszYWeMmhVmnauo=";
  };

  build-system = [ setuptools ];

  checkPhase = ''
    runHook preCheck

    python -c 'import trianglesolver; trianglesolver.run_lots_of_tests()'

    runHook postCheck
  '';

  meta = {
    description = "Finds all the sides and angles of a triangle, if you know some of the sides and/or angles";
    homepage = "https://pypi.org/project/trianglesolver/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tnytown ];
  };
}
