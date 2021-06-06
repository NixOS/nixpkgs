{ lib, buildPythonPackage, fetchPypi,
  flake8, py, pyflakes, six, tox
}:

buildPythonPackage rec {
  pname = "serpy";
  version = "0.3.1";

  meta = {
    description = "ridiculously fast object serialization";
    homepage = "https://github.com/clarkduvall/serpy";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "3772b2a9923fbf674000ff51abebf6ea8f0fca0a2cfcbfa0d63ff118193d1ec5";
  };

  buildInputs = [ flake8 py pyflakes tox ];
  propagatedBuildInputs = [ six ];

  # ImportError: No module named 'tests
  doCheck = false;
}
