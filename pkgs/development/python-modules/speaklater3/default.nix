{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "speaklater3";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ySYdS2taMEZyMS0esImb4Cj6yRdgGQqA/szTHTo7UEI=";
  };

  pythonImportsCheck = [ "speaklater" ];

  meta = with lib; {
    description = "Implements a lazy string for python useful for use with gettext";
    homepage = "https://github.com/mitsuhiko/speaklater";
    license = licenses.bsd0;
    maintainers = with maintainers; [ gador ];
  };
}
