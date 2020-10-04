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
  version = "0.28.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c08dbb90c116626cb6c5f19ebd14cd4846cffe7151f338c19215e6938d334980";
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
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
