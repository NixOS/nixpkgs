{ buildPythonPackage
, fetchPypi
, lib
, stdenv
, pythonOlder
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

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [
    appdirs
    distlib
    filelock
    six
  ] ++ lib.optionals (pythonOlder "3.3") [
    contextlib2
  ] ++ lib.optionals (pythonOlder "3.4" && !stdenv.hostPlatform.isWindows) [
    pathlib2
  ] ++ lib.optionals (pythonOlder "3.7") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # TODO: remove this once https://github.com/NixOS/nixpkgs/issues/81441 is solved
  postCheck = ''
    for pycache in $(find $out -name __pycache__) ; do
      rm -fr ''${pycache}
    done
  '';

  meta = {
    description = "A tool to create isolated Python environments";
    homepage = "http://www.virtualenv.org";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ goibhniu ];
  };
}
