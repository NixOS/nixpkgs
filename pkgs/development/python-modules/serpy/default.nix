{ lib, buildPythonPackage, fetchPypi,
  flake8, py, pyflakes, six, tox
}:

buildPythonPackage rec {
  pname = "serpy";
  name = "${pname}-${version}";
  version = "0.1.1";

  meta = {
    description = "ridiculously fast object serialization";
    homepage = https://github.com/clarkduvall/serpy;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r9wn99x9nbqxfancnq9jh3cn83i1b6gc79xj0ipnxixp661yj5i";
  };

  buildInputs = [ flake8 py pyflakes tox ];
  propagatedBuildInputs = [ six ];

  # ImportError: No module named 'tests
  doCheck = false;
}
