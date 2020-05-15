{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mq8lmb1wh55cqdj7javq7qia4217h6vf5ljc99gsjyibi7g7d3k";
  };

  propagatedBuildInputs = [ pyyaml setuptools ];

  makeWrapperArgs = ["--prefix" "PATH" ":" (stdenv.lib.makeBinPath [ git bazaar subversion ])];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = "https://github.com/dirk-thomas/vcstool";
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
