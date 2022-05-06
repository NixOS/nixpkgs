{ lib
, buildPythonApplication
, fetchFromGitHub
, poetry
, pygls
, pyparsing
, cmake
, pytest-datadir
, pytestCheckHook
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pyparsing = "^2.4"' 'pyparsing = "^3.0.6"'
  '';

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ pygls pyparsing ];

  checkInputs = [ cmake pytest-datadir pytestCheckHook ];
  dontUseCmakeConfigure = true;
  pythonImportsCheck = [ "cmake_language_server" ];

  meta = with lib; {
    description = "CMake LSP Implementation";
    homepage = "https://github.com/regen100/cmake-language-server";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
