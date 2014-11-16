{stdenv, fetchurl, transfig, texLiveAggregationFun, texLive, texLiveExtra, ghostscript
, build-manual ? false
}:

stdenv.mkDerivation rec {
  name = "ragel-${version}";
  version = "6.9";

  src = fetchurl {
    url = "http://www.colm.net/wp-content/uploads/2014/10/${name}.tar.gz";
    sha256 = "02k6rwh8cr95f1p5sjjr3wa6dilg06572xz1v71dk8awmc7vw1vf";
  };

  buildInputs = stdenv.lib.optional build-manual [ transfig ghostscript (texLiveAggregationFun { paths=[ texLive texLiveExtra ]; }) ];
   
  preConfigure = stdenv.lib.optional build-manual ''
    sed -i "s/build_manual=no/build_manual=yes/g" DIST
  '';
  
  meta = with stdenv.lib; {
    homepage = http://www.complang.org/ragel;
    description = "State machine compiler";
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
  };
}
