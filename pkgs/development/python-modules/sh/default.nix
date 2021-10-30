{ lib, buildPythonPackage, fetchPypi, fetchpatch, python, coverage, lsof, glibcLocales, coreutils }:

buildPythonPackage rec {
  pname = "sh";
  version = "1.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d7bd0334d494b2a4609fe521b2107438cdb21c0e469ffeeb191489883d6fe0d";
  };

  patches = [
    # Disable tests that fail on Darwin sandbox
    ./disable-broken-tests-darwin.patch
  ];

  postPatch = ''
    sed -i 's#/usr/bin/env python#${python.interpreter}#' test.py
    sed -i 's#/bin/sleep#${coreutils.outPath}/bin/sleep#' test.py
  '';

  checkInputs = [ coverage lsof glibcLocales ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Python subprocess interface";
    homepage = "https://pypi.python.org/pypi/sh/";
    license = licenses.mit;
    maintainers = with maintainers; [ siriobalmelli ];
  };
}
