{ lib, buildPythonApplication, fetchFromGitHub, isPy3k
, opentimestamps, appdirs, GitPython, pysocks, fetchpatch, git
}:

buildPythonApplication rec {
  pname = "opentimestamps-client";
  version = "0.7.1";
  disabled = (!isPy3k);

  # We can't use the pypi source because it doesn't include README.md which is
  # needed in setup.py
  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "refs/tags/opentimestamps-client-v${version}";
    sha256 = "sha256-0dWaXetRlF1MveBdJ0sAdqJ5HCdn08gkbX+nen/ygsQ=";
  };

  propagatedBuildInputs = [ opentimestamps appdirs GitPython pysocks ];

  meta = {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = "https://github.com/opentimestamps/opentimestamps-client";
    license = lib.licenses.lgpl3;
  };
}
