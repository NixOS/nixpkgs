{ lib, buildPythonApplication, fetchPypi, isPy3k, blessings, docopt }:

buildPythonApplication rec {
  pname = "cbeams";
  version = "1.0.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8Q2sWsAc39Mu34K1wWOKOJERKzBStE4GmtuzOs2T7Kk=";
  };

  propagatedBuildInputs = [ blessings docopt ];

  meta = with lib; {
    homepage = "https://github.com/tartley/cbeams";
    description = "Command-line program to draw animated colored circles in the terminal";
    license = licenses.bsd3;
    maintainers = with maintainers; [ oxzi ];
  };
}
