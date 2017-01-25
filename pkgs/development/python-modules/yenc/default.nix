{ fetchurl
, lib
, buildPythonPackage
, python
, isPyPy
, isPy3k
}:

let
  pname = "yenc";
  version = "0.4.0";
in buildPythonPackage {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/dual75/yenc/get/${version}.tar.gz";
    sha256 = "0zkyzxgq30mbrzpnqam4md0cb09d5falh06m0npc81nnlhcghkp7";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover -s test
  '';

  disabled = isPy3k || isPyPy;

  meta = {
    description = "Encoding and decoding yEnc";
    license = lib.licenses.lgpl21;
    homepage = https://bitbucket.org/dual75/yenc;
    maintainers = with lib.maintainers; [ fridh ];
  };
}