{ lib
, buildPythonApplication
, fetchFromGitHub
, poetry
, cmake-format
, pygls
, pyparsing
, cmake
, pytest-datadir
, pytestCheckHook
}:

buildPythonApplication rec {
  pname = "cmake-language-server";
  version = "0.1.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4GchuxArSJKnl28ckefJgbqxyf1fOU0DUj8R50upTcQ=";
  };

  patches = [
    # Test timeouts occasionally cause the build to fail
    ./disable-test-timeouts.patch

    # cmake-language-server depends on pygls 0.11, but still works with 0.12
    ./use-latest-pygls.patch
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pyparsing = "^2.4"' 'pyparsing = "^3.0.6"'
  '';

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    cmake-format
    pygls
    pyparsing
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
