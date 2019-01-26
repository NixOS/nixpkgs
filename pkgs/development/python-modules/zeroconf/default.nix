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
  version = "0.21.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b52dfdf4e665d98a17bf9aa50dea7a8c98e25f972d9c1d7660e2b978a1f5713";
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
