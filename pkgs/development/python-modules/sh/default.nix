{ stdenv, buildPythonPackage, fetchPypi, python, coverage, lsof }:

buildPythonPackage rec {
  pname = "sh";
  version = "1.12.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z2hx357xp3v4cv44xmqp7lli3frndqpyfmpbxf7n76h7s1zaaxm";
  };

  # Disable tests that fail on Darwin
  # Some of the failures are due to Nix using GNU coreutils
  patches = [ ./disable-broken-tests-darwin.patch ];

  postPatch = ''
    sed -i 's#/usr/bin/env python#${python.interpreter}#' test.py
  '';

  checkInputs = [ coverage lsof  ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    HOME=$(mktemp -d)
  '';

  meta = {
    description = "Python subprocess interface";
    homepage = https://pypi.python.org/pypi/sh/;
    license = stdenv.lib.licenses.mit;
  };
}
