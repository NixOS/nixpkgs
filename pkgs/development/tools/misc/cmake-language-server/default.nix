{ lib
, buildPythonApplication
, fetchFromGitHub
, cmake-format
, pygls
, cmake
, pdm-pep517
, pytest-datadir
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "cmake-language-server";
  version = "unstable-2023-01-08";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = pname;
    rev = "60c376a5fda29835060687569cb212350a292116";
    hash = "sha256-vNG43sZy2wMetY5mbgxIoei5jCCj1f8vWiovWtwzbPc=";
  };

  PDM_PEP517_SCM_VERSION = "2023.1";

  patches = [
    # Test timeouts occasionally cause the build to fail
    ./disable-test-timeouts.patch
  ];

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    cmake-format
    pygls
  ];

  nativeCheckInputs = [
    cmake
    cmake-format
    pytest-datadir
    pytestCheckHook
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "cmake_language_server"
  ];

  meta = with lib; {
    description = "CMake LSP Implementation";
    homepage = "https://github.com/regen100/cmake-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
