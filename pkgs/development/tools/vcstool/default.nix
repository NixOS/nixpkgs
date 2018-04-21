{ stdenv, python3Packages
, git, bazaar, subversion }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "vcstool";
  version = "0.1.35";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c52ef4bae424deb284d042005db22844dae290758af77d76cac37d26bed9ad1c";
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
