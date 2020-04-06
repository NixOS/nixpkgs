{ stdenv
, buildPythonPackage
, fetchFromGitHub
, glibcLocales
, urwid
}:

buildPythonPackage rec {
  pname = "urwidtrees";
  version  = "1.0.2";

  src = fetchFromGitHub {
    owner = "pazz";
    repo = "urwidtrees";
    rev = version;
    sha256 = "1n1kpidvkdnsqyb82vlvk78gmly96kh8351lqxn2pzgwwns6fml2";
  };

  propagatedBuildInputs = [ urwid ];

  checkInputs = [ glibcLocales ];
  LC_ALL="en_US.UTF-8";

  meta = with stdenv.lib; {
    description = "Tree widgets for urwid";
    homepage = https://github.com/pazz/urwidtrees;
    license = licenses.gpl3;
  };

}
