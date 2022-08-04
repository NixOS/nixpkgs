{ lib
, buildPythonApplication
, fetchFromGitHub
, poetry
, cmake-format
, pygls
, cmake
, pytest-datadir
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "cmake-language-server";
  version = "0.1.6";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-B7dhCQo3g2E8+fzyl1RhaYQE6TFoqoLtp9Z7sZcv5xk=";
  };

  patches = [
    # Test timeouts occasionally cause the build to fail
    ./disable-test-timeouts.patch
  ];

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    cmake-format
    pygls
  ];

  checkInputs = [
    cmake
    cmake-format
    pytest-datadir
    pytestCheckHook
  ];

  dontUseCmakeConfigure = true;
  pythonImportsCheck = [ "cmake_language_server" ];

  meta = with lib; {
    description = "CMake LSP Implementation";
    homepage = "https://github.com/regen100/cmake-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
