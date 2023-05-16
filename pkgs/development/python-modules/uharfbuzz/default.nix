{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, cython
, setuptools-scm
, pytestCheckHook
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "uharfbuzz";
<<<<<<< HEAD
  version = "0.37.0";
=======
  version = "0.24.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.5";

<<<<<<< HEAD
=======
  # Fetching from GitHub as Pypi contains different versions
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "harfbuzz";
    repo = "uharfbuzz";
    rev = "v${version}";
<<<<<<< HEAD
    fetchSubmodules = true;
    hash = "sha256-CZp+/5fG5IBawnIZLeO9lXke8rodqRcSf+ofyF584mc=";
=======
    hash = "sha256-DyFXbwB28JH2lvmWDezRh49tjCvleviUNSE5LHG3kUg=";
    fetchSubmodules = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    cython
    setuptools-scm
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ ApplicationServices ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "uharfbuzz" ];

  meta = with lib; {
    description = "Streamlined Cython bindings for the harfbuzz shaping engine";
    homepage = "https://github.com/harfbuzz/uharfbuzz";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ wolfangaukang ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
