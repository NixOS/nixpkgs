{ stdenv, fetchPypi, buildPythonPackage
, traits, pyface, wxPython
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "6.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kw1xy5ax6l0lzmk7pfzjw6qs0idv78k3118my7cbvw1n5iiff28";
  };

  propagatedBuildInputs = [ traits pyface wxPython ];

  doCheck = false; # Needs X server

  meta = with stdenv.lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/traitsui";
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
