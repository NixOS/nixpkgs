{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {

  name = "${pname}-${version}";
  pname = "rst2html5";
  version = "1.9.3";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "1js90asy7s0278b4p28inkkp0r7ajr5fk5pcdgcdw628a30vl3i6";
  };

  propagatedBuildInputs = with pythonPackages;
  [ docutils genshi pygments beautifulsoup4 ];

  meta = with stdenv.lib;{
    homepage = "https://bitbucket.org/andre_felipe_dias/rst2html5";
    description = "Converts ReSTructuredText to (X)HTML5";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
