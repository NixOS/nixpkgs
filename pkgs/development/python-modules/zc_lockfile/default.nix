{ buildPythonPackage
, fetchPypi
, mock
, zope-testing
, lib
}:

buildPythonPackage rec {
  pname = "zc.lockfile";
  version = "3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Y/9ndYsbUMuhoK/oZbJDKw+XB4/JNrjuJ1ggihV14g=";
  };

  buildInputs = [ mock ];
  propagatedBuildInputs = [ zope-testing ];

  meta = with lib; {
    description = "Inter-process locks";
    homepage =  "https://www.python.org/pypi/zc.lockfile";
    license = licenses.zpl20;
    maintainers = with maintainers; [ goibhniu ];
  };
}
