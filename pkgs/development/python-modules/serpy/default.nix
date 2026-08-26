{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "serpy";
  version = "0.3.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3772b2a9923fbf674000ff51abebf6ea8f0fca0a2cfcbfa0d63ff118193d1ec5";
  };

  propagatedBuildInputs = [ six ];

  # ImportError: No module named 'tests
  doCheck = false;

  pythonImportsCheck = [ "serpy" ];

  meta = {
    description = "Ridiculously fast object serialization";
    homepage = "https://github.com/clarkduvall/serpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
