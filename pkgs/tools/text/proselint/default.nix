{
  lib,
  fetchurl,
  buildPythonApplication,
  click,
  future,
  six,
}:

buildPythonApplication rec {
  pname = "proselint";
  version = "0.13.0";

  doCheck = false; # fails to pass because it tries to run in home directory

  src = fetchurl {
    url = "mirror://pypi/p/proselint/${pname}-${version}.tar.gz";
    sha256 = "7dd2b63cc2aa390877c4144fcd3c80706817e860b017f04882fbcd2ab0852a58";
  };

  propagatedBuildInputs = [
    click
    future
    six
  ];

  meta = with lib; {
    description = "Linter for prose";
    mainProgram = "proselint";
    homepage = "http://proselint.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alibabzo ];
  };
}
