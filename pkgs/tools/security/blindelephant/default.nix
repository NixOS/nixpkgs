{ lib, python2, fetchsvn }:

python2.pkgs.buildPythonApplication rec {
  pname = "blindelephant";
  version = "7";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/blindelephant/code/trunk/src";
    rev = version;
    sha256 = "0caqlmml23zz3bf0d0q795b2gml62zz78fd4cci8fsh2ydsgz2lg";
  };

  # Project doesn't contain tests
  doCheck = false;
  pythonImportsCheck = [ "blindelephant" ];

  meta = with lib; {
    description = "A generic web application fingerprinter that produces results by examining a small set of static files";
    homepage = "http://blindelephant.sourceforge.net/";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ emilytrau ];
  };
}
