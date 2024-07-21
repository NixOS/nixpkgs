{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "holehe";
  version = "unstable-2023-05-18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "megadose";
    repo = "holehe";
    rev = "bec2f582c286a4e32de4dfc1f241297f60bd8713";
    hash = "sha256-dLfuQew6cqb32r9AMubuo51A7TeaIafEdZs0OrQF7Gg=";
  };

  postPatch = ''
    # https://github.com/megadose/holehe/pull/178
    substituteInPlace setup.py \
      --replace "bs4" "beautifulsoup4"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    beautifulsoup4
    colorama
    httpx
    termcolor
    tqdm
    trio
  ];

  # Project has no test
  doCheck = false;

  pythonImportsCheck = [
    "holehe"
  ];

  meta = with lib; {
    description = "CLI to check if the mail is used on different sites";
    mainProgram = "holehe";
    homepage = "https://github.com/megadose/holehe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
