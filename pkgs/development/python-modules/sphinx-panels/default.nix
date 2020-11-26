{ lib
, buildPythonPackage
, fetchPypi
, docutils
, sphinx
, importlib-resources
}:

buildPythonPackage rec {
  pname = "sphinx-panels";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7b3faa05f37b7318fd14cd85c4effa1ab905dfc8bed236a63978565ea461ae4";
  };

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # sphinx>=2,<4
  # importlib-resources~=3.0.0; python_version < "3.7"
  # # Extra packages (may not be necessary)
  # sphinx-rtd-theme # themes
  # pydata-sphinx-theme~=0.4.0 # themes
  # sphinx-book-theme~=0.0.36 # themes
  # myst-parser~=0.12.9 # themes
  # pre-commit~=2.7.0 # code_style
  # pytest~=6.0.1 # testing
  # pytest-regressions~=2.0.1 # testing
  # sphinx-autobuild # live-dev
  # web-compile~=0.2.0 # live-dev
  propagatedBuildInputs = [
    docutils
    sphinx
    importlib-resources
  ];

  meta = with lib; {
    description = "A sphinx extension for creating panels in a grid layout";
    homepage = https://github.com/executablebooks/sphinx-panels;
    license = licenses.mit;
    # maintainers = [ maintainers. ];
  };
}