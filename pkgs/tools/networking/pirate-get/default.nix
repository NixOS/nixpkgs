{ stdenv, python3Packages }:

with python3Packages;

buildPythonApplication rec {
  name = "${pname}-${version}";
  pname = "pirate-get";
  version = "0.2.13";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5b159e02067136d3157d56061958a50e997a078510e4403bb7de40217833f3f";
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
