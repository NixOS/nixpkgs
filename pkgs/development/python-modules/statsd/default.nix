{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pynose,
  mock,
}:

buildPythonPackage rec {
  pname = "statsd";
  version = "4.0.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mXY9qBv+qNr2s9ItEarMsBqND1LqUh2qs351ikyn0Sg=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pynose
    mock
  ];

  checkPhase = ''
    nosetests -sv
  '';

  meta = with lib; {
    maintainers = with maintainers; [ domenkozar ];
    description = "Simple statsd client";
    license = licenses.mit;
    homepage = "https://github.com/jsocol/pystatsd";
  };
}
