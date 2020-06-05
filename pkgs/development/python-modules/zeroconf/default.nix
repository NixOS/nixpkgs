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
  version = "0.26.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "43ad5006c00be2040cdca1fe768206f4a25356d3cc87eff8b66bd7ead2a82440";
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
