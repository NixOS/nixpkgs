{ stdenv, buildPythonPackage, fetchPypi, fetchpatch, python, coverage, lsof, glibcLocales }:

buildPythonPackage rec {
  pname = "sh";
  version = "1.12.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z2hx357xp3v4cv44xmqp7lli3frndqpyfmpbxf7n76h7s1zaaxm";
  };

  patches = [
    # Disable tests that fail on Darwin
    # Some of the failures are due to Nix using GNU coreutils
    ./disable-broken-tests-darwin.patch
    # Fix tests for Python 3.7. See: https://github.com/amoffat/sh/pull/468
    (fetchpatch {
      url = "https://github.com/amoffat/sh/commit/b6202f75706473f02084d819e0765056afa43664.patch";
      sha256 = "1kzxyxcc88zhgn2kmfg9yrbs4n405b2jq7qykb453l52hy10vi94";
      excludes = [ ".travis.yml" ];
    })
  ];

  postPatch = ''
    sed -i 's#/usr/bin/env python#${python.interpreter}#' test.py
  '';

  checkInputs = [ coverage lsof glibcLocales ];

  # A test needs the HOME directory to be different from $TMPDIR.
  preCheck = ''
    export LC_ALL="en_US.UTF-8"
    HOME=$(mktemp -d)
  '';

  meta = {
    description = "Python subprocess interface";
    homepage = https://pypi.python.org/pypi/sh/;
    license = stdenv.lib.licenses.mit;
  };
}
