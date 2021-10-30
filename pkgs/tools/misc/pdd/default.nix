{ lib, fetchFromGitHub, buildPythonApplication, python-dateutil }:

buildPythonApplication rec {
  pname = "pdd";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "pdd";
    rev = "v${version}";
    sha256 = "1ivzcbm888aibiihw03idp38qbl8mywj1lc1x0q787v0pzqfb4ss";
  };

  format = "other";

  propagatedBuildInputs = [ python-dateutil ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
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
    maintainers = [ maintainers.infinisil ];
    license = licenses.gpl3;
  };
}
