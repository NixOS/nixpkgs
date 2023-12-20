{ lib
, buildPythonPackage
, fetchPypi
, nose
, pep8
}:

buildPythonPackage rec {
  pname = "tissue";
  version = "0.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e34726c3ec8fae358a7faf62de172db15716f5582e5192a109e33348bd76c2e";
  };

  buildInputs = [ nose ];
  propagatedBuildInputs = [ pep8 ];

  meta = with lib; {
    homepage = "https://github.com/WoLpH/tissue";
    description = "Tissue - automated pep8 checker for nose";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
