{ lib, fetchurl, buildPythonApplication, click, future, six }:

buildPythonApplication rec {
  pname = "proselint";
  version = "0.13.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${pname}-${version}.tar.gz";
    hash = "sha256-fdK2PMKqOQh3xBRPzTyAcGgX6GCwF/BIgvvNKrCFKlg=";
  };

  propagatedBuildInputs = [ click future six ];

  meta = with lib; {
    description = "Linter for prose";
    mainProgram = "proselint";
    homepage = "http://proselint.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
