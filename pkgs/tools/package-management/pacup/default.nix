{ lib
, fetchFromGitHub
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

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ httpx rich typer packaging ];

  meta = with lib; {
    description = "Help maintainers update pacscripts";
    longDescription = ''
      Pacup (Pacscript Updater) is a maintainer helper tool to help maintainers update their pacscripts.
      It semi-automates the tedious task of updating pacscripts, and aims to make it a fun process for the maintainer!
    '';
    homepage = "https://github.com/pacstall/pacup";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ zahrun ];
    broken = true; # requires older typer version, update requires httpx 0.24.X
  };
}
