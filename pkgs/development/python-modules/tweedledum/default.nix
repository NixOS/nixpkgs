{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, cmake
, ninja
, scikit-build
  # Check Inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "tweedledum";
  version = "1.1.1";
  format = "pyproject";

  src = fetchFromGitHub{
    owner = "boschmitt";
    repo = "tweedledum";
    rev = "v${version}";
    hash = "sha256-wgrY5ajaMYxznyNvlD0ul1PFr3W8oV9I/OVsStlZEBM=";
  };

<<<<<<< HEAD
  postPatch = ''
    sed -i '/\[project\]/a version = "${version}"' pyproject.toml
    sed -i '/\[project\]/a name = "tweedledum"' pyproject.toml
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [ cmake ninja scikit-build ];
  dontUseCmakeConfigure = true;

  pythonImportsCheck = [ "tweedledum" ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "python/test" ];

  meta = with lib; {
    description = "A library for synthesizing and manipulating quantum circuits";
    homepage = "https://github.com/boschmitt/tweedledum";
    license = licenses.mit ;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
