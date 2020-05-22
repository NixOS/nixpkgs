{ buildPythonPackage
, fetchPypi
, lib
, appdirs
, contextlib2
, distlib
, filelock
, importlib-metadata
, importlib-resources
, pathlib2
, setuptools_scm
, six
}:

buildPythonPackage rec {
  pname = "virtualenv";
  version = "20.0.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kxnxxwa25ghlkpyrxa8pi49v87b7ps2gyla7d1h6kbz9sfn45m1";

  };

  propagatedBuildInputs = [
    appdirs
    contextlib2
    distlib
    filelock
    importlib-metadata
    importlib-resources
    pathlib2
    setuptools_scm
    six
  ];

  meta = {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goibhniu ];
  };
}
