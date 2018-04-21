{ lib, buildPythonApplication, fetchFromGitHub, isPy3k
, opentimestamps, GitPython, pysocks }:

buildPythonApplication rec {
  name = "opentimestamps-client-${version}";
  version = "0.5.1";
  disabled = (!isPy3k);

  src = fetchFromGitHub {
    owner = "opentimestamps";
    repo = "opentimestamps-client";
    rev = "opentimestamps-client-v0.5.1";
    sha256 = "0s549xkb75r5wyvjlfmac8a1df6w0y55l98f492zsihdns1d6rzq";
  };

  propagatedBuildInputs = [ opentimestamps GitPython pysocks ];

  meta = {
    description = "Command-line tool to create and verify OpenTimestamps proofs";
    homepage = https://github.com/opentimestamps/opentimestamps-client;
    license = lib.licenses.lgpl3;
  };
}
