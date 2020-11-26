{ lib
, buildPythonPackage
, fetchPypi
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinx-thebe";
  version = "0.0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6229caa99e996776ffdc5c658d9dcce09e0c749727e5aa3d280a2bbf3a72068a";
  };

  # # Package conditions to handle
  # # might have to sed setup.py and egg.info in patchPhase
  # # sed -i "s/<package>.../<package>/"
  # sphinx (>=1.8)
  # # Extra packages (may not be necessary)
  # myst-parser[sphinx] ; extra == 'sphinx'
  # sphinx-book-theme ; extra == 'sphinx'
  # jupyter-sphinx ; extra == 'sphinx'
  # sphinx-panels ; extra == 'sphinx'
  # pytest ; extra == 'testing'
  # pytest-regressions ; extra == 'testing'
  # beautifulsoup4 ; extra == 'testing'
  propagatedBuildInputs = [
    sphinx
  ];

  meta = with lib; {
    description = "Integrate interactive code blocks into your documentation with Thebe and Binder";
    homepage = https://github.com/executablebooks/sphinx-thebe;
    license = licenses.mit;
    # maintainers = [ maintainers. ];
  };
}