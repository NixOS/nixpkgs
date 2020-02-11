{ stdenv
, buildPythonPackage
, fetchPypi
, ifaddr
, typing
, isPy27
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.24.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f66d38f16026097572939ab78b1f46a97f556bca415491eb0fd094d0b5827dfe";
  };

  propagatedBuildInputs = [ ifaddr ]
    ++ stdenv.lib.optionals (pythonOlder "3.5") [ typing ];

  # tests not included with pypi release
  doCheck = false;

  checkPhase = ''
    ${python.interpreter} test_zeroconf.py
  '';

  meta = with stdenv.lib; {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = https://github.com/jstasiak/python-zeroconf;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
