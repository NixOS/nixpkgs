{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib
, setuptools-scm
, pytestCheckHook
, typing-extensions
, sphinxHook
, sphinx-autodoc-typehints
, sphinx-rtd-theme
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "2.13.3";
  disabled = pythonOlder "3.5";
  outputs = [ "out" "doc" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "00edaa8da3a133674796cf5ea87d9f4b4c367d77476e185e80251cc13dfbb8c4";
  };

  nativeBuildInputs = [
    glibcLocales
    setuptools-scm
    sphinxHook
    sphinx-autodoc-typehints
    sphinx-rtd-theme
  ];

  LC_ALL = "en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg --replace " --cov" ""
  '';

  nativeCheckInputs = [ pytestCheckHook typing-extensions ];

  disabledTestPaths = [
    # mypy tests aren't passing with latest mypy
    "tests/mypy"
  ];

  disabledTests = [
    # not compatible with python3.10
    "test_typed_dict"
  ];

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
