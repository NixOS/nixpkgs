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
  version = "3.5.2";
  name = "${pname}-${version}";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb2b989cf03ffc7166339eb34f1aa26c5ace255243337b1e22dab7caa1166687";
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