{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {

  name = "${pname}-${version}";
  pname = "rst2html5";
  version = "1.9.4";

  src = fetchurl {
    url = "mirror://pypi/${builtins.substring 0 1 pname}/${pname}/${name}.tar.gz";
    sha256 = "d044589d30eeaf7336986078b7bd175510fd649a212b01a457d7806b279e6c73";
  };

  propagatedBuildInputs = with pythonPackages;
  [ docutils genshi pygments beautifulsoup4 ];

  meta = with stdenv.lib;{
    homepage = https://bitbucket.org/andre_felipe_dias/rst2html5;
    description = "Converts ReSTructuredText to (X)HTML5";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
