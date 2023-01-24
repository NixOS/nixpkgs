{ lib
, stdenv
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gallia";
  version = "1.0.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Fraunhofer-AISEC";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CoZ3niGuEjcaSyIGc0MIy95v64nTbhgqW/0uz4a/f1o=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aiofiles
    aiohttp
    aiosqlite
    argcomplete
    can
    construct
    msgspec
    pydantic
    tabulate
    tomlkit
    xdg
    zstandard
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'aiofiles = "^0.8.0"' 'aiofiles = ">=0.8.0"' \
      --replace 'zstandard = "^0.17.0"' 'zstandard = "*"'
  '';

  pythonImportsCheck = [
    "gallia"
  ];

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "Pentesting framework with the focus on the automotive domain";
    homepage = "https://github.com/Fraunhofer-AISEC/gallia";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
