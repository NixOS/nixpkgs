{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "pirate-get";
  version = "0.3.0";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "171dd2d387fd8af726abcf4cac0d806463bedc8e5f892655179fb4b215df47b2";
  };

  propagatedBuildInputs = [ colorama veryprettytable beautifulsoup4 ];

  meta = with stdenv.lib; {
    description = "A command line interface for The Pirate Bay";
    homepage = https://github.com/vikstrous/pirate-get;
    license = licenses.gpl1;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.unix;
  };
}
