{ buildPythonPackage
, fetchPypi
, mock
, zope_testing
, stdenv
}:

buildPythonPackage rec {
  pname = "zc.lockfile";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "307ad78227e48be260e64896ec8886edc7eae22d8ec53e4d528ab5537a83203b";
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
