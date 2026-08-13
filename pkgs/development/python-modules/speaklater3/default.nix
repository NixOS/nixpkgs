{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "speaklater3";
  version = "1.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ySYdS2taMEZyMS0esImb4Cj6yRdgGQqA/szTHTo7UEI=";
  };

  pythonImportsCheck = [ "speaklater" ];

  meta = {
    description = "Implements a lazy string for python useful for use with gettext";
    homepage = "https://github.com/mitsuhiko/speaklater";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ gador ];
  };
}
