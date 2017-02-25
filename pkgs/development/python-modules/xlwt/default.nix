{ buildPythonPackage
, fetchurl
, fetchpatch
, nose
, lib
}:

buildPythonPackage rec {
  pname = "xlwt";
  name = "${pname}-${version}";
  version = "1.1.2";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "aed648c17731f40f84550dd2a1aaa53569f0cbcaf5610ba895cd2632587b723c";
  };

  # re.LOCALE was removed in Python 3.6
  patches = [
    (fetchpatch {
      url = "https://github.com/python-excel/xlwt/commit/86564ef26341020316cd8a27c704ef1dc5a6129b.patch";
      sha256 = "0ifavfld3rrqjb0iyriy4c0drw31gszvlg3nmnn9dmfsh91vxhs6";
    })
  ];

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