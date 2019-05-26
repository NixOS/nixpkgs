{ stdenv
, buildPythonPackage
, fetchgit
, lxml
, isPy27
}:

buildPythonPackage {
  pname = "svg2tikz";
  version = "1.0.0";
  disabled = ! isPy27;

  propagatedBuildInputs = [ lxml ];

  src = fetchgit {
    url = "https://github.com/kjellmf/svg2tikz";
    sha256 = "429428ec435e53672b85cdfbb89bb8af0ff9f8238f5d05970729e5177d252d5f";
    rev = "ad36f2c3818da13c4136d70a0fd8153acf8daef4";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/kjellmf/svg2tikz;
    description = "An SVG to TikZ converter";
    license = licenses.gpl2Plus;
    maintainers =  with maintainers; [ gal_bolle ];
  };

}
