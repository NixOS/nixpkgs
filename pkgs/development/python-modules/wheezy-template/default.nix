{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wheezy.template";
  version = "0.1.195";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1wpdhy58rb0xavbr80nk5xjw75gv0fzwn1anjgpnq30y7lga92pr";
  };

  meta = {
    homepage = "https://wheezytemplate.readthedocs.io/en/latest/";
    description = "A lightweight template library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
