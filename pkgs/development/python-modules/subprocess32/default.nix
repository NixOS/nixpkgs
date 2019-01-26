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
  version = "3.5.3";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bc82992316eef3ccff319b5033809801c0c3372709c5f6985299c88ac7225c3";
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