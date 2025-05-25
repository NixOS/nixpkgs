{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python-dateutil,
}:

buildPythonApplication {
  pname = "pdd";
  version = "1.7-unstable-2025-01-11";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "pdd";
    rev = "ced6d1df79571dcb21a4c68970ee612855858db0";
    hash = "sha256-yggNdBYIg2nqf5e/pkhKNzoKGR/k1Ny/hWafe3tdqF0=";
  };

  postPatch = ''
    patchShebangs auto-completion/zsh/zsh_completion.py
  '';

  propagatedBuildInputs = [ python-dateutil ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/jarun/pdd";
    description = "Tiny date, time diff calculator";
    longDescription = ''
      There are times you want to check how old you are (in years, months, days)
      or how long you need to wait for the next flash sale or the number of days
      left of your notice period in your current job. pdd (Python3 Date Diff) is
      a small cmdline utility to calculate date and time difference. If no
      program arguments are specified it shows the current date, time and
      timezone.
    '';
    maintainers = [ ];
    license = lib.licenses.gpl3;
    mainProgram = "pdd";
  };
}
