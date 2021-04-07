{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "screenlogicpy";
  version = "0.3.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gn2mf2n2g1ffdbijrydgb7dgd60lkvckblx6s86kxlkrp1wqgrq";
  };

  # Project doesn't publish tests
  # https://github.com/dieselrabbit/screenlogicpy/issues/8
  doCheck = false;
  pythonImportsCheck = [ "screenlogicpy" ];

  meta = with lib; {
    description = "Python interface for Pentair Screenlogic devices";
    homepage = "https://github.com/dieselrabbit/screenlogicpy";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
