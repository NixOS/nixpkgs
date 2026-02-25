{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  cmake,
  pybind11,
  setuptools,
  setuptools-scm,
  boost183,
  ncurses,
  pythonOlder,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "ur-rtde";
  version = "1.6.0";
  pyproject = true;

  # newer versions fails on deprecations
  disabled = pythonOlder "3.11" || pythonAtLeast "3.12";

  src = fetchFromGitLab {
    owner = "sdurobotics";
    repo = "ur_rtde";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-Aj/+XVlcjloNctf4lUU2Rb+Zu+GkzckqHdAZGvyIqZQ=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeBuildInputs = [
    cmake
    pybind11
  ];

  buildInputs = [
    # boost has to be pinned to 1.83 for compilation to succeed
    boost183
    ncurses
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "rtde_control"
    "rtde_receive"
    "rtde_io"
  ];

  postPatch = ''
    # Prevent CMake from trying to download pybind11 via git during the build
    # Use the system pybind11 instead
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(pybind11)" "find_package(pybind11 REQUIRED)" \
      --replace-fail "FetchContent_MakeAvailable(pybind11-src)" "find_package(pybind11 REQUIRED)"
  '';

  meta = with lib; {
    description = "A python binding for C++ library used to controll and data collection from a UR robot using the Real-Time Data Exchange (RTDE) interface";
    homepage = "https://gitlab.com/sdurobotics/ur_rtde";
    license = licenses.mit;
    maintainers = with maintainers; [ stepisptr-t ];
  };
}
