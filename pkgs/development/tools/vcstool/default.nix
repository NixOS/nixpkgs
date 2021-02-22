{ lib, python3Packages
, git, breezy, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.2.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b1fce6fcef7b117b245a72dc8658a128635749d01dc7e9d1316490f89f9c2fde";
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
