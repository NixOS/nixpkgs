{ lib, python3Packages, fetchPypi
, git, breezy, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BLOpY+FThmYPE55bldKT5D48tBTjsT4U7jb1IjAy7iw=";
  };

  propagatedBuildInputs = [ pyyaml setuptools ];

  makeWrapperArgs = ["--prefix" "PATH" ":" (lib.makeBinPath [ git breezy subversion ])];

  doCheck = false; # requires network

  meta = with lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = "https://github.com/dirk-thomas/vcstool";
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
