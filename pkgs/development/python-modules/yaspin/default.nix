{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, termcolor
}:

buildPythonPackage rec {
  pname = "yaspin";
<<<<<<< HEAD
  version = "3.0.1";
=======
  version = "2.3.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pavdmyt";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-cYTCJyHZ9yNg6BfpZ+g3P0yMWFhYUxgYtlbANNgfohQ=";
=======
    hash = "sha256-TURfjhEqkg8TT7dsoIOn2iAeD7+lX8+s9hItritf1GU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    termcolor
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    # https://github.com/pavdmyt/yaspin/pull/212
    substituteInPlace pyproject.toml \
      --replace 'termcolor-whl = "1.1.2"' 'termcolor = "*"'
  '';

  pythonImportsCheck = [
    "yaspin"
  ];

  meta = with lib; {
    description = "Yet Another Terminal Spinner";
    homepage = "https://github.com/pavdmyt/yaspin";
    license = licenses.mit;
    maintainers = with maintainers; [ samuela ];
  };
}
