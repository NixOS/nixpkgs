{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib
, setuptools-scm
, pytestCheckHook
, typing-extensions
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.13.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4";
  };

  buildInputs = [ setuptools-scm ];
  nativeBuildInputs = [ glibcLocales ];

  LC_ALL="en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  checkInputs = [ pytestCheckHook typing-extensions ];

  disabledTestPaths = [
    # mypy tests aren't passing with latest mypy
    "tests/mypy"
  ];

  disabledTests = [
    # not compatible with python3.10
    "test_typed_dict"
  ];

  disabled = pythonOlder "3.3";

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
  };
}
