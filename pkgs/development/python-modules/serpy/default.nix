{ stdenv, lib, buildPythonPackage, fetchPypi,
  flake8, py, pyflakes, six, tox
}:

buildPythonPackage rec {
  pname = "serpy";
  name = "${pname}-${version}";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r9wn99x9nbqxfancnq9jh3cn83i1b6gc79xj0ipnxixp661yj5i";
  };

  # ImportError: No module named 'tests
  doCheck = false;

  buildInputs = [ flake8 py pyflakes tox ];
  propagatedBuildInputs = [ six ];

  meta = {
    description = "ridiculously fast object serialization";
    homepage = https://github.com/clarkduvall/serpy;
    license = lib.licenses.mit;
  };
}
