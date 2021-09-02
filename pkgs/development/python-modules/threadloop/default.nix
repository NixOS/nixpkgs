{ lib, buildPythonPackage, fetchPypi
, tornado
, flake8, ipdb, pytest, pytest-cov, twine, zest_releaser, coveralls
}:

buildPythonPackage rec {
  pname = "threadloop";
  version = "1.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b180aac31013de13c2ad5c834819771992d350267bddb854613ae77ef571944";
  };

  propagatedBuildInputs = [
    tornado
  ];

  checkInputs = [
    flake8
    ipdb
    pytest
    pytest-cov
    twine
    zest_releaser
    coveralls
  ];
  checkPhase = ''
    pytest
  '';
  # ImportError: cannot import name 'ThreadLoop' from 'threadloop'
  doCheck = false;

  pythonImportsCheck = [ "threadloop" ];

  meta = with lib; {
    description = "A library to run tornado coroutines from synchronous Python";
    downloadPage = "https://pypi.org/project/threadloop/";
    homepage = "https://github.com/GoodPete/threadloop";
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
}
