{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zope.event";
  version = "4.0.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w858k9kmgzfj36h65kp27m9slrmykvi5cjq6c119xqnaz5gdzgm";
  };

  meta = with stdenv.lib; {
    description = "An event publishing system";
    homepage = https://pypi.python.org/pypi/zope.event;
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };

}
