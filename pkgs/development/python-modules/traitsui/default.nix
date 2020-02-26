{ stdenv, fetchPypi, buildPythonPackage
, traits, pyface, wxPython
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "6.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "080fq9hag7hvcnsd5c5fn74zjmjl6rjq40r0zwdz2bjlk9049xpi";
  };

  propagatedBuildInputs = [ traits pyface wxPython ];

  doCheck = false; # Needs X server

  meta = with stdenv.lib; {
    description = "Traits-capable windowing framework";
    homepage = https://github.com/enthought/traitsui;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
