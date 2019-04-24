{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, requests
, python
}:

buildPythonPackage rec {
  pname = "wikipedia";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "db0fad1829fdd441b1852306e9856398204dc0786d2996dd2e0c8bb8e26133b2";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} -m unittest discover tests/ '*test.py'

    runHook postCheck
  '';

  meta = with lib; {
    description = "Wikipedia API for Python";
    homepage = https://github.com/goldsmith/Wikipedia;
    license = licenses.mit;
    maintainers = [ maintainers.worldofpeace ];
  };
}
