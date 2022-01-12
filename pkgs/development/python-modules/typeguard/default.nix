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
  version = "2.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e50071590ab997509aa0977609eb5cf9d73d84c1f416cb4fab78b77a9d15326";
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
