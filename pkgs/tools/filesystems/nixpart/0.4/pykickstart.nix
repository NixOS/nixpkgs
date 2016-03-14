{ stdenv, python, buildPythonApplication, fetchurl, urlgrabber }:

buildPythonApplication rec {
  name = "pykickstart-${version}";
  version = "1.99.39";

  src = fetchurl rec {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/pykickstart/"
        + "${name}.tar.gz/${md5}/${name}.tar.gz";
    md5 = "d249f60aa89b1b4facd63f776925116d";
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
    homepage = "http://fedoraproject.org/wiki/Pykickstart";
    description = "Read and write Fedora kickstart files";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
