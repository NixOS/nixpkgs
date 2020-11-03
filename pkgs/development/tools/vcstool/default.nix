{ stdenv, python3Packages
, git, breezy, subversion }:

with python3Packages;

buildPythonApplication rec {
  pname = "vcstool";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lb0j120sj76swi702ah6ryn770m1y7gh69237zxpyh897pn5paa";
  };

  requiredPythonModules = [ pyyaml setuptools ];

  makeWrapperArgs = ["--prefix" "PATH" ":" (stdenv.lib.makeBinPath [ git breezy subversion ])];

  doCheck = false; # requires network

  meta = with stdenv.lib; {
    description = "Provides a command line tool to invoke vcs commands on multiple repositories";
    homepage = "https://github.com/dirk-thomas/vcstool";
    license = licenses.asl20;
    maintainers = with maintainers; [ sivteck ];
  };
}
