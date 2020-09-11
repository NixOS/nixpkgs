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
  version = "0.28.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "447d6da0b6426c0c67d5c29339e51b2d75e2c1f129605ad35a0cb84a454f09bc";
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
