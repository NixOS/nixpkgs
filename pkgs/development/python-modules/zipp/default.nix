{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, more-itertools
}:

buildPythonPackage rec {
  pname = "zipp";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d";
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
