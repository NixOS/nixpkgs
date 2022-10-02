{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, isPy27
}:

buildPythonPackage {
  pname = "svg2tikz";
  version = "1.0.0";
  disabled = ! isPy27;

  propagatedBuildInputs = [ lxml ];

  src = fetchFromGitHub {
    owner = "kjellmf";
    repo = "svg2tikz";
    rev = "ad36f2c3818da13c4136d70a0fd8153acf8daef4";
    sha256 = "sha256-QpQo7ENeU2crhc37uJu4rw/5+COPXQWXBynlF30lLV8=";
    fetchSubmodules = true;
  };

  meta = with lib; {
    homepage = "https://github.com/kjellmf/svg2tikz";
    description = "An SVG to TikZ converter";
    license = licenses.gpl2Plus;
    maintainers =  with maintainers; [ gal_bolle ];
  };

}
