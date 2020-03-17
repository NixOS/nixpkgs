{ stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy3k
, eventlib
, application
}:

buildPythonPackage rec {
  pname = "python-xcaplib";
  version = "1.2.2";
  disabled = isPy3k;

  src = fetchFromGitHub {
    owner = "AGProjects";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-K05xcZ7SVStgDeboxhFQILNpegrO7ke2jrti+Nxe+QY=";
  };

  propagatedBuildInputs = [ eventlib application ];

  meta = with stdenv.lib; {
    homepage = https://github.com/AGProjects/python-xcaplib;
    description = "XCAP (RFC4825) client library";
    license = licenses.gpl2;
  };

}
