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
    sha256 = "sha256-wgrY5ajaMYxznyNvlD0ul1PFr3W8oV9I/OVsStlZEBM=";
  };

  nativeBuildInputs = [ cmake ninja scikit-build ];
  dontUseCmakeConfigure = true;

  # error: 'value' is unavailable: introduced in macOS 10.13
  CXXFLAGS = lib.optional (stdenv.hostPlatform.system == "x86_64-darwin") "-D_LIBCPP_DISABLE_AVAILABILITY";

  pythonImportsCheck = [ "tweedledum" ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "python/test" ];

  meta = with lib; {
    description = "A library for synthesizing and manipulating quantum circuits";
    homepage = "https://github.com/boschmitt/tweedledum";
    license = licenses.mit ;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
