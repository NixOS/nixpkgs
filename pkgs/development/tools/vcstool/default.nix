{ stdenv, python3Packages
, git, breezy, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.2.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c51300f074ea9c5da162ed8f3bc354c3fd69564895fee90abf1e1bd525919f2b";
  };

  propagatedBuildInputs = [ pyyaml setuptools ];

  makeWrapperArgs = ["--prefix" "PATH" ":" (stdenv.lib.makeBinPath [ git breezy subversion ])];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = "https://github.com/dirk-thomas/vcstool";
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
