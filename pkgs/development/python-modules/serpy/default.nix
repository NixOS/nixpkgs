{ lib, buildPythonPackage, fetchPypi,
  flake8, py, pyflakes, six, tox
}:

buildPythonPackage rec {
  pname = "serpy";
  name = "${pname}-${version}";
  version = "0.2.0";

  meta = {
    description = "ridiculously fast object serialization";
    homepage = https://github.com/clarkduvall/serpy;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e62e242321b208362966d5ab32b45df93b1cb88da4ce6260277da060b4f7475";
  };

  buildInputs = [ flake8 py pyflakes tox ];
  propagatedBuildInputs = [ six ];

  # ImportError: No module named 'tests
  doCheck = false;
}
