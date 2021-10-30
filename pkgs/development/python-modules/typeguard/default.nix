{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib
, setuptools-scm
, pytest
, typing-extensions
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c2af8b9bdd7657f4bd27b45336e7930171aead796711bc4cfc99b4731bb9d051";
  };

  buildInputs = [ setuptools-scm ];
  nativeBuildInputs = [ glibcLocales ];

  LC_ALL="en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  checkInputs = [ pytest typing-extensions ];

  # mypy tests aren't passing with latest mypy
  checkPhase = ''
    py.test . --ignore=tests/mypy
  '';

  disabled = pythonOlder "3.3";

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
  };
}
