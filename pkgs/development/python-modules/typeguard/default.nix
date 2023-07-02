{ lib
, buildPythonPackage
, fetchPypi
, glibcLocales
, importlib-metadata
, mypy
, pytestCheckHook
, pythonOlder
, setuptools-scm
, sphinx-autodoc-typehints
, sphinx-rtd-theme
, sphinxHook
, typing-extensions
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "4.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GU+z28sG6pyvcIjzvv7gFN5XlhaJ+chZrFI5se9h2Yc=";
  };

  LC_ALL = "en_US.utf-8";

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov" ""
  '';

  nativeBuildInputs = [
    glibcLocales
    setuptools-scm
    sphinxHook
    sphinx-autodoc-typehints
    sphinx-rtd-theme
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "typeguard"
  ];

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    changelog = "https://github.com/agronholm/typeguard/blob/${version}/docs/versionhistory.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
