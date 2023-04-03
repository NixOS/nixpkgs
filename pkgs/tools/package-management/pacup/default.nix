{ lib
, fetchFromGitHub
, python3
, buildPythonApplication
, poetry-core
, httpx
, rich
, typer
, packaging
}:
buildPythonApplication rec {
  name = "pacup";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pacstall";
    repo = name;
    rev = version;
    hash = "sha256-Hl/Gq/cZz4RGYKTuyDlrhATAUYEzKEuYIm0JdToN/ZY=";
  };

  nativeBuildInputs = with python3; [ poetry-core ];

  propagatedBuildInputs = with python3; [ httpx rich typer packaging ];

  meta = with lib; {
    description = "Help maintainers update pacscripts";
    longDescription = ''
      Pacup (Pacscript Updater) is a maintainer helper tool to help maintainers update their pacscripts.
      It semi-automates the tedious task of updating pacscripts, and aims to make it a fun process for the maintainer!
    '';
    homepage = "https://github.com/pacstall/pacup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zahrun ];
  };
}
