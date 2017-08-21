{ buildPythonPackage
, fetchurl
, fetchpatch
, nose
, lib
}:

buildPythonPackage rec {
  pname = "xlwt";
  name = "${pname}-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "505669c1eb6a60823fd3e2e723b60eea95f2c56254113bf163091ed2bedb4ac9";
  };

  buildInputs = [ nose ];
  checkPhase = ''
    nosetests -v
  '';

  meta = {
    description = "Library to create spreadsheet files compatible with MS";
    homepage = https://github.com/python-excel/xlwt;
    license = with lib.licenses; [ bsdOriginal bsd3 lgpl21 ];
  };
}