{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vcstool";
  version = "0.1.33";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1140d3ecafb2c42c2c1a309950c7f327b09b548c00fbf6e37c8f44b8a610dfbc";
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
