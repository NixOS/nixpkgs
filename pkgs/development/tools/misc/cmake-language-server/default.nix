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
  version = "0.1.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = "cmake-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-ExEAi47hxxEJeoT3FCwpRwJrf3URnI47/5FDL7fS5sY=";
  };

  PDM_PEP517_SCM_VERSION = version;

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
