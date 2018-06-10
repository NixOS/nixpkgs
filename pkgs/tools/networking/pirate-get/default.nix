{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "pirate-get";
  version = "0.2.12";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q6hvavj0gswgw3x756h18nmmpnxlgg08qvxphpbzlwd43xrnza3";
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
