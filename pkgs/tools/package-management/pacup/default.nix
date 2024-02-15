{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  name = "pacup";
  version = "2.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pacstall";
    repo = name;
    rev = "refs/tags/${version}";
    hash = "sha256-ItO38QyxNHftKPQZAPO7596ddBfX0a1nfVVqgx7BfwI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'httpx = ">=0.24,<0.25"' 'httpx = "*"'
  '';

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httpx
    rich
    typer
    packaging
  ];

  meta = with lib; {
    description = "Help maintainers update pacscripts";
    longDescription = ''
      Pacup (Pacscript Updater) is a maintainer helper tool to help maintainers update their pacscripts.
      It semi-automates the tedious task of updating pacscripts, and aims to make it a fun process for the maintainer!
    '';
    homepage = "https://github.com/pacstall/pacup";
    changelog = "https://github.com/pacstall/pacup/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zahrun ];
    mainProgram = "pacup";
  };
}
