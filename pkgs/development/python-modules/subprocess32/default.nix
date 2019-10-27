{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, isPyPy
, bash
, python
}:

buildPythonPackage rec {
  pname = "subprocess32";
  version = "3.5.4";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb2937c80497978d181efa1b839ec2d9622cf9600a039a79d0e108d1f9aec79d";
  };

  buildInputs = [ bash ];

  preConfigure = ''
    substituteInPlace test_subprocess32.py \
      --replace '/usr/' '${bash}/'
  '';

  doCheck = !isPyPy;
  checkPhase = ''
    ${python.interpreter} test_subprocess32.py
  '';

  meta = {
    homepage = https://pypi.python.org/pypi/subprocess32;
    description = "Backport of the subprocess module from Python 3.2.5 for use on 2.x";
    maintainers = with lib.maintainers; [ ];
  };
}
