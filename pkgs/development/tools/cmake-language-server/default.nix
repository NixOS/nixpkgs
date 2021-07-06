{ lib, stdenv, buildPythonApplication, fetchFromGitHub
, poetry, pygls, pyparsing
, cmake, pytest, pytest-datadir
, fetchpatch
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

  patches = [
    ./disable-test-timeouts.patch
  ] ++ lib.optionals stdenv.isDarwin [
    # can be removed after v0.1.2
    (fetchpatch {
      url = "https://github.com/regen100/cmake-language-server/commit/0ec120f39127f25898ab110b43819e3e9becb8a3.patch";
      sha256 = "1xbmarvsvzd61fnlap4qscnijli2rw2iqr7cyyvar2jd87z6sfp0";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'pygls = "^0.8.1"' 'pygls = "^0.9.0"'
  '';

  nativeBuildInputs = [ poetry ];
  propagatedBuildInputs = [ pygls pyparsing ];

  checkInputs = [ cmake pytest pytest-datadir ];
  dontUseCmakeConfigure = true;
  checkPhase = "pytest";

  meta = with lib; {
    homepage = "https://github.com/regen100/cmake-language-server";
    description = "CMake LSP Implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ kira-bruneau ];
  };
}
