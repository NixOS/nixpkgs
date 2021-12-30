{ lib
, buildPythonApplication
, fetchFromGitHub
, poetry
, pygls
, pyparsing
, cmake
, pytest-datadir
, pytestCheckHook
, cmake-language-server
, testVersion
}:

buildPythonApplication rec {
  pname = "cmake-language-server";
  version = "0.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eZBnygEYjLzk29tvLGg1JdhCECc5x2MewHRSChMuCjo=";
  };

  patches = [
    # Test timeouts occasionally cause the build to fail
    ./disable-test-timeouts.patch
  ];

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ pygls pyparsing ];

  checkInputs = [ cmake pytest-datadir pytestCheckHook ];
  dontUseCmakeConfigure = true;
  pythonImportsCheck = [ "cmake_language_server" ];

  passthru.tests.version = testVersion { package = cmake-language-server; };

  meta = with lib; {
    description = "CMake LSP Implementation";
    homepage = "https://github.com/regen100/cmake-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
