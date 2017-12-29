{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vcstool";
  version = "0.1.31";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n2zkvy2km9ky9lljf1mq5nqyqi5qqzfy2a6sgkjg2grvsk7abxc";
  };

  propagatedBuildInputs = [ pyyaml ];

  makeWrapperArgs = ["--prefix" "PATH" ":" "${stdenv.lib.makeBinPath [ git bazaar subversion ]}"];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = https://github.com/dirk-thomas/vcstool;
    license = licenses.asl20;
    maintainer = with maintainers; [ sivteck ];
  };
}
