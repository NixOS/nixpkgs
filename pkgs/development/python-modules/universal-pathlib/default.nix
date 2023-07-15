{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, fsspec
}:

buildPythonPackage rec {
  pname = "universal-pathlib";
  version = "0.0.23";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "fsspec";
    repo = "universal_pathlib";
    rev = "v${version}";
    hash = "sha256-UT4S7sqRn0/YFzFL1KzByK44u8G7pwWHERzJEm7xmiw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    fsspec
  ];

  pythonImportsCheck = [ "upath" ];

  meta = with lib; {
    description = "Pathlib api extended to use fsspec backends";
    homepage = "https://github.com/fsspec/universal_pathlib";
    changelog = "https://github.com/fsspec/universal_pathlib/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
