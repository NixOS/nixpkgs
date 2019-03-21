{ buildPythonPackage
, fetchPypi
, mock
, zope_testing
, stdenv
}:

buildPythonPackage rec {
  pname = "zc.lockfile";
  version = "1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0lrj2zdr06sff7i151710jbbnnhx4phdc0qpns8jkarpd62f7a4m";
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
