{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname   = "twitter.common.options";
  version = "0.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0d1czag5mcxg0vcnlklspl2dvdab9kmznsycj04d3vggi158ljrd";
  };

  meta = with stdenv.lib; {
    description = "Twitter's optparse wrapper";
    homepage    = "https://twitter.github.io/commons/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ copumpkin ];
  };

}
