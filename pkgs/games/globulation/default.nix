{ stdenv, fetchurl, libGLU_combined, SDL, scons, SDL_ttf, SDL_image, zlib, SDL_net
, speex, libvorbis, libogg, boost, fribidi, bsdiff
, fetchpatch
}:
let
  version = "0.9.4";
  patchlevel = "4";
  tutorial4patch = fetchurl {
    url = "http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=34;filename=tutorial-part4.map.bspatch;att=1;bug=595448";
    name = "globulation2-tutorial4-map-patch-debian.bspatch";
    sha256 = "d3511ac0f822d512c42abd34b3122f2990862d3d0af6ce464ff372f5bd7f35e9";
  };
in
stdenv.mkDerivation rec {
  name = "glob2-${version}.${patchlevel}";

  src = fetchurl {
    url = "mirror://savannah/glob2/${version}/${name}.tar.gz";
    sha256 = "1f0l2cqp2g3llhr9jl6jj15k0wb5q8n29vqj99xy4p5hqs78jk8g";
  };

  patches = [ ./header-order.patch ./public-buildproject.patch
    (fetchpatch {
	  url = https://bitbucket.org/giszmo/glob2/commits/c9dc715624318e4fea4abb24e04f0ebdd9cd8d2a/raw;
	  sha256 = "0017xg5agj3dy0hx71ijdcrxb72bjqv7x6aq7c9zxzyyw0mkxj0k";
	})
  ];

  postPatch = ''
    cp campaigns/tutorial-part4.map{,.orig}
    bspatch  campaigns/tutorial-part4.map{.orig,} ${tutorial4patch}
    sed -i -e "s@env = Environment()@env = Environment( ENV = os.environ )@" SConstruct
  '';

  buildInputs = [ libGLU_combined SDL scons SDL_ttf SDL_image zlib SDL_net speex libvorbis libogg boost fribidi bsdiff ];

  buildPhase = ''
    scons
  '';

  installPhase = ''
    scons install \
      BINDIR=$out/bin \
      INSTALLDIR=$out/share/globulation2 \
      DATADIR=$out/share/globulation2/glob2
  '';
      
  meta = with stdenv.lib; {
    description = "RTS without micromanagement";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
  passthru.updateInfo.downloadPage = "http://globulation2.org/wiki/Download_and_Install";
}

