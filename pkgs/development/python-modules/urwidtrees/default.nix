{ stdenv
, buildPythonPackage
, fetchFromGitHub
, urwid
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  version  = "1.0";

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    rev = "${version}";
    sha256 = "03gpcdi45z2idy1fd9zv8v9naivmpfx65hshm8r984k9wklv1dsa";
  };

  propagatedBuildInputs = [ urwid ];

  meta = with stdenv.lib; {
    description = "Tree widgets for urwid";
    homepage = https://github.com/pazz/urwidtrees;
    license = licenses.gpl3;
  };

}
