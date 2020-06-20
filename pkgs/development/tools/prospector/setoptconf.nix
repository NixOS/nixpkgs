{ buildPythonPackage
, fetchPypi
, lib
}:

buildPythonPackage rec {
  pname = "setoptconf";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "177l7j68j751i781bgk6pfhxjj7hwqxzdm2ja5fkywbp0275s2sv";
  };

  # Base tests provided via PyPi are broken
  doCheck = false;

  meta = with lib; {
    homepage = "https://pypi.org/project/setoptconf";
    description = "A module for retrieving program settings from various sources in a consistant method";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
