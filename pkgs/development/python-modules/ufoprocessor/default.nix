{ lib, buildPythonPackage, fetchPypi
, defcon, fonttools, lxml, fs
, mutatormath, fontmath, fontparts
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "ufoProcessor";
  version = "1.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ns11aamgavgsfj8qf5kq7dvzmgl0mhr1cbych2f075ipfdvva5s";
    extension = "zip";
  };

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    defcon
    lxml
    fonttools
    fs
    fontmath
    fontparts
    mutatormath
  ];

  meta = with lib; {
    description = "Read, write and generate UFOs with designspace data";
    homepage = "https://github.com/LettError/ufoProcessor";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
