{ lib, buildPythonApplication, fetchFromGitHub, isPy3k
, opentimestamps, appdirs, GitPython, pysocks }:

buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.6.0";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "opentimestamps-client-v${version}";
    sha256 = "05m8nllqad3k69mvby5q08y22i0wrj84gqifdgcldimrrn1i00xp";
  };

  propagatedBuildInputs = [ opentimestamps appdirs GitPython pysocks ];

  meta = {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/opentimestamps-client;
    license = lib.licenses.lgpl3;
  };
}
