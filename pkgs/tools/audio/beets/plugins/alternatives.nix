{
  lib,
  fetchFromGitHub,
  beets,
  imagemagick,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "beets-alternatives";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    repo = "beets-alternatives";
    owner = "geigerzaehler";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-+LvQC7hYtbJeWJiDEKtSFZaEtnuXZ+4mI75rrX9Sd64=";
  };

  propagatedBuildInputs = [
    imagemagick
  ];

  nativeBuildInputs = [
    beets
    python3Packages.poetry-core
  ];

  nativeCheckInputs = with python3Packages; [
    imagemagick
    pytestCheckHook
    pytest-cov
    mock
    typeguard
  ];
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
    description = "Beets plugin to manage external files";
    homepage = "https://github.com/geigerzaehler/beets-alternatives";
    maintainers = with lib.maintainers; [
      aszlig
      lovesegfault
    ];
    license = lib.licenses.mit;
  };
}
