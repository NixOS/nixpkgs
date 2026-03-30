{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  python-dateutil,
}:

buildPythonApplication rec {
  pname = "pdd";
  version = "1.7";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "pdd";
    tag = "v${version}";
    hash = "sha256-jQCjqQxvJU2oYLSWpFriJIfD0EbqBx59AvRX77pX0Cg=";
  };

  postPatch = ''
    patchShebangs auto-completion/zsh/zsh_completion.py
  '';

  preInstall = ''
    mkdir -p $out/share/bash-completion/compilations
    mkdir -p $out/share/zsh/site-functions
    mkdir -p $out/share/fish/vendor_completions.d
  '';

  dependencies = [ python-dateutil ];

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
    license = lib.licenses.gpl3Plus;
    mainProgram = "pdd";
  };
}
