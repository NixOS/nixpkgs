{ lib
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "singledispatch";
  version = "3.4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c";
  };

  propagatedBuildInputs = [ six ];

  # pypi singledispatch tarbal does not contain tests
  doCheck = false;

  meta = {
    description = "This library brings functools.singledispatch from Python 3.4 to Python 2.6-3.3.";
    homepage = https://docs.python.org/3/library/functools.html;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
  };
}
