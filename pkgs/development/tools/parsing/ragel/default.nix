{stdenv, fetchurl, transfig, tex , ghostscript, colm,  build-manual ? false
}:

stdenv.mkDerivation rec {
  name = "ragel-${version}";
  version = "7.0.0.6";

  src = fetchurl {
    url = "http://www.colm.net/files/ragel/${name}.tar.gz";
    sha256 = "1ns3kbcvhinn4rwm54ajg49d1la8filxskl3rgbwws0irzw507vs";
  };

  buildInputs = stdenv.lib.optional build-manual [ transfig ghostscript tex ];
   
  preConfigure = stdenv.lib.optional build-manual ''
    sed -i "s/build_manual=no/build_manual=yes/g" DIST
  '';

  configureFlags = [ "--with-colm=${colm}" ];

  doCheck = true;
  
  meta = with stdenv.lib; {
    homepage = http://www.complang.org/ragel;
    description = "State machine compiler";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
  };
}
