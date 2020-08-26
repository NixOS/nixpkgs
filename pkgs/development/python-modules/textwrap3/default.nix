{ lib
, buildPythonPackage
, fetchPypi
, tox
, pytest
, coverage
, pytestcov
}:

buildPythonPackage rec {
  pname = "textwrap3";
  version = "0.9.2";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5008eeebdb236f6303dcd68f18b856d355f6197511d952ba74bc75e40e0c3414";
  };

  checkInputs = [
    tox
    pytest
    coverage
    pytestcov
  ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Textwrap from Python 3.6 backport plus a few tweaks";
    homepage = "https://github.com/jonathaneunice/textwrap3";
    license = licenses.psfl;
    maintainers = [ maintainers.costrouc ];
  };
}
