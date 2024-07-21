{ lib, fetchFromGitHub, beets, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-U72pflNFwShZzEtgzEl1UcgZqw4oB3y+h39MM+zUdyM=";
  };

  nativeBuildInputs = [
    beets
    python3Packages.poetry-core
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov
    mock
    typeguard
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    maintainers = with maintainers; [ aszlig lovesegfault ];
    license = licenses.mit;
  };
}
