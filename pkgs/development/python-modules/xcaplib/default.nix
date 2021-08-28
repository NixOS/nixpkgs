{ lib
, buildPythonPackage
, fetchdarcs
, isPy3k
, eventlib
, application
}:

buildPythonPackage rec {
  pname = "python-xcaplib";
  version = "1.2.1";
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "15ww8f0a9zh37mypw5s4q1qk44cwf7jlhc9q1z4vjlpvnzimg54v";
  };

  propagatedBuildInputs = [ eventlib application ];

  meta = with lib; {
    homepage = "https://github.com/AGProjects/python-xcaplib";
    description = "XCAP (RFC4825) client library";
    license = licenses.gpl2;
  };

}
