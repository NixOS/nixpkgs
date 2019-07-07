{ buildPythonPackage, stdenv, fetchPypi, pytest, unicodecsv, pandas
, xlwt, openpyxl, pyyaml, xlrd, odfpy, fetchpatch
}:

buildPythonPackage rec {
  pname = "tablib";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11wxchj0qz77dn79yiq30k4b4gsm429f4bizk4lm4rb63nk51kxq";
  };

  checkInputs = [ pytest unicodecsv pandas ];
  propagatedBuildInputs = [ xlwt openpyxl pyyaml xlrd odfpy ];

  patches = [
    (fetchpatch {
      url = "https://github.com/kennethreitz/tablib/commit/0e51a2d0944022af186d2dcd34c0ab3c47141ba5.patch";
      sha256 = "0lbbl871zdn5vpgqyjkil0c2ap3b5hz19rmihhyvrx7m4mlh1aij";
    })
  ];

  meta = with stdenv.lib; {
    description = "Tablib: format-agnostic tabular dataset library";
    homepage = http://python-tablib.org;
    license = licenses.mit;
  };
}
