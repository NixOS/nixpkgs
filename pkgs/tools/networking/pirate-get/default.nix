{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "pirate-get";
  version = "0.2.10";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "04gsilbyq2plldzi495dcf19h5xfldfyn6zdczj2fdki1m29jyr0";
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
