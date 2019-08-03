{ stdenv
, buildPythonPackage
, fetchdarcs
, isPy3k
, eventlib
, application
}:

buildPythonPackage rec {
  pname = "python-xcaplib";
  version = "1.2.0";
  disabled = isPy3k;

  src = fetchdarcs {
    url = "http://devel.ag-projects.com/repositories/${pname}";
    rev = "release-${version}";
    sha256 = "0vna5r4ihv7z1yx6r93954jqskcxky77znzy1m9dg9vna1dgwfdn";
  };

  propagatedBuildInputs = [ eventlib application ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AGProjects/python-xcaplib;
    description = "XCAP (RFC4825) client library";
    license = licenses.gpl2;
  };

}
