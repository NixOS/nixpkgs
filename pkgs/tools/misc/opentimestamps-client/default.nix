{ lib, buildPythonApplication, fetchFromGitHub, isPy3k
, opentimestamps, appdirs, GitPython, pysocks, fetchpatch, git
}:

buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.7.0";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "opentimestamps-client-v${version}";
    sha256 = "1aiq9cwr40md54swzm7wkwj0h65psxmvj2japvw79s9x0pp8iwqs";
  };

  propagatedBuildInputs = [ opentimestamps appdirs GitPython pysocks ];

  meta = {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/opentimestamps-client;
    license = lib.licenses.lgpl3;
  };
}
