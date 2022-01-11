{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, more-itertools
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ more-itertools ];

  # Prevent infinite recursion with pytest
  doCheck = false;

  meta = with lib; {
    description = "Pathlib-compatible object wrapper for zip files";
    homepage = "https://github.com/jaraco/zipp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
