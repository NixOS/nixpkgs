{ stdenv
, buildPythonPackage
, isPy3k
, fetchPypi
, six
, wxPython
}:

buildPythonPackage rec {
  pname = "squaremap";
  version = "1.0.5";
  disabled = isPy3k;

  src = fetchPypi {
    pname = "SquareMap";
    inherit version;
    sha256 = "1a79jm7mp0pvi3a19za5c3idavnj7hlral01hhr3x9mz1jayav5i";
  };

  propagatedBuildInputs = [ six wxPython ];

  meta = with stdenv.lib; {
    description = "Hierarchic visualization control for wxPython";
    homepage = https://launchpad.net/squaremap;
    license = licenses.bsd3;
    broken = true; # wxPython doesn't seem to be able to be detected by pip
  };

}
