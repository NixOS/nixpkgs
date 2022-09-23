{ lib
, buildPythonPackage
, fetchPypi
, appdirs
, requests
, click
, setuptools
, backends ? [ ]
}:

buildPythonPackage rec {
  pname = "taxi";
  version = "6.1.1";

  src = fetchPypi {
    inherit version;
    pname = "taxi";
    sha256 = "b2562ed58bd6eae7896f4f8e48dbee9845cd2d452b26dd15c26f839b4864cb02";
  };

  # No tests in pypy package
  doCheck = false;

  propagatedBuildInputs = [
    appdirs
    requests
    click
    setuptools
  ] ++ backends;

  meta = with lib; {
    homepage = "https://github.com/sephii/taxi/";
    description = "Timesheeting made easy";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ jocelynthode ];
  };
}
