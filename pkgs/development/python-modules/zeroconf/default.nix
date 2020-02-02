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
  version = "0.24.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "de62e5067ea7ab356f7168a3562d79fececa8632ed0fad0e82f505e01fafbc6d";
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
