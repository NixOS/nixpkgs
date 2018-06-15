{ stdenv, python, buildPythonApplication, fetchurl, urlgrabber }:

buildPythonApplication rec {
  name = "pykickstart-${version}";
  version = "1.99.39";
  md5_path = "d249f60aa89b1b4facd63f776925116d";

  src = fetchurl rec {
    url = "http://src.fedoraproject.org/repo/pkgs/pykickstart/"
        + "${name}.tar.gz/${md5_path}/${name}.tar.gz";
    sha256 = "e0d0f98ac4c5607e6a48d5c1fba2d50cc804de1081043f9da68cbfc69cad957a";
  };

  postPatch = ''
    sed -i -e "s/for tst in tstList/for tst in sorted(tstList, \
               key=lambda m: m.__name__)/" tests/baseclass.py
  '';

  propagatedBuildInputs = [ urlgrabber ];

  checkPhase = ''
    export PYTHONPATH="$PYTHONPATH:."
    ${python}/bin/${python.executable} tests/baseclass.py -vv
  '';

  meta = {
    homepage = http://fedoraproject.org/wiki/Pykickstart;
    description = "Read and write Fedora kickstart files";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
