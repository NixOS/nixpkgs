<<<<<<< HEAD
{ lib, python3Packages, fetchPypi
=======
{ lib, python3Packages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, git, breezy, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04b3a963e15386660f139e5b95d293e43e3cb414e3b13e14ee36f5223032ee2c";
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
