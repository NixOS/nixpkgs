{ stdenv
, buildPythonPackage
, fetchFromGitHub
, cherrypy
, bottle
, lockfile
, clize
}:

buildPythonPackage rec {
  pname = "zerobin";
  version = "20160108";

  src = fetchFromGitHub {
    owner = "sametmax";
    repo = "0bin";
    rev = "7da1615";
    sha256 = "1pzcwy454kn5216pvwjqzz311s6jbh7viw9s6kw4xps6f5h44bid";
  };

  propagatedBuildInputs = [ cherrypy bottle lockfile clize ];

  # zerobin doesn't have any tests, but includes a copy of cherrypy which
  # can wrongly fail the check phase.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A client side encrypted pastebin";
    homepage = https://0bin.net/;
    license = licenses.wtfpl;
  };

}
