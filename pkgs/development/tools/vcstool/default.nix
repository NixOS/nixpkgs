{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.1.36";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c3d347f46cda641344ec5d613896499981b0540e2bfa299baf6026dab7649ca";
  };

  propagatedBuildInputs = [ pyyaml ];

  makeWrapperArgs = ["--prefix" "PATH" ":" "${stdenv.lib.makeBinPath [ git bazaar subversion ]}"];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = https://github.com/dirk-thomas/vcstool;
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
