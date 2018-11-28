{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, django
, smartypants
, jinja2
}:

buildPythonPackage rec {
  pname = "typogrify";
  version = "2.0.7";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38";
  };

  propagatedBuildInputs = [ django smartypants jinja2 ];

  # Wants to set up Django
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Filters to enhance web typography, including support for Django & Jinja templates";
    homepage = "https://github.com/mintchaos/typogrify";
    license = licenses.bsd3;
    maintainers = with maintainers; [ garbas ];
  };

}
