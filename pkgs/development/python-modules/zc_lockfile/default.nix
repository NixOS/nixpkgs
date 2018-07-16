{ buildPythonPackage
, fetchPypi
, mock
, zope_testing
, stdenv
}:

buildPythonPackage rec {
  pname = "zc.lockfile";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96cb13769e042988ea25d23d44cf09342ea0f887083d0f9736968f3617665853";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ zope_testing ];

  meta = with stdenv.lib; {
    description = "Inter-process locks";
    homepage =  https://www.python.org/pypi/zc.lockfile;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
