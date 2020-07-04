{ stdenv, buildPythonApplication, fetchFromGitHub
, poetry, pygls, pyparsing
, cmake, pytest, pytest-datadir
}:

buildPythonApplication rec {
  pname = "cmake-language-server";
  version = "0.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "regen100";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vz7bjxkk0phjhz3h9kj6yr7wnk3g7lqmkqraa0kw12mzcfck837";
  };

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ pygls pyparsing ];

  checkInputs = [ cmake pytest pytest-datadir ];
  dontUseCmakeConfigure = true;
  checkPhase = "pytest";

  meta = with stdenv.lib; {
    homepage = "https://github.com/regen100/cmake-language-server";
    description = "CMake LSP Implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
