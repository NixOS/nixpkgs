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
  version = "3.2.7";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e450a4a4c53bf197ad6402c564b9f7a53539385918ef8f12bdf430a61036590";
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
    maintainers = with lib.maintainers; [ garbas ];
  };
}