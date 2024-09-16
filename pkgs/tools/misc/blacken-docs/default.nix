{ black
, fetchFromGitHub
, lib
, python3
}:
python3.pkgs.buildPythonApplication rec {
  pname = "blacken-docs";
  version = "1.15.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "adamchainz";
    repo = "blacken-docs";
    rev = version;
    hash = "sha256-3FGuFOAHCcybPwujWlh58NWtuF5CebaKTgBWgCGpSL8=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
  ];

  propagatedBuildInputs = [
    black
  ];

  nativeCheckInputs = [
    black
    python3.pkgs.pytestCheckHook
  ];

  meta = with lib; {
    homepage = "https://github.com/adamchainz/blacken-docs";
    changelog = "https://github.com/adamchainz/blacken-docs/blob/${src.rev}/CHANGELOG.rst";
    description = "Run Black on Python code blocks in documentation files";
    license = licenses.mit;
    maintainers = with maintainers; [ l0b0 ];
    mainProgram = "blacken-docs";
  };
}
