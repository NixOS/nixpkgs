{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "jefferson";
  version = "0.4.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "onekey-sec";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zW38vcDw4Jz5gO9IHrWRlvUznKvUyPbxkYMxn7VSTpA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    cstruct
    python-lzo
  ];

  pythonImportsCheck = [
    "jefferson"
  ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "JFFS2 filesystem extraction tool";
    homepage = "https://github.com/onekey-sec/jefferson";
    license = licenses.mit;
    maintainers = with maintainers; [ tnias ];
  };
}
