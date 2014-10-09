{ stdenv, fetchurl, scons, pkgconfig, openssl, protobuf, boost, zlib}:

stdenv.mkDerivation rec {
  name = "rippled-${version}";
  version = "0.23.0";

  src = fetchurl {
    url = "https://github.com/ripple/rippled/archive/${version}.tar.gz";
    sha256 = "0js734sk11jn19fyp403mk6p62azlc6s9kyhr5jfg466fiak537p";
  };

  patches = [ ./scons-env.patch ];

  buildInputs = [ scons pkgconfig openssl protobuf boost zlib ];

  RIPPLED_BOOST_HOME = boost.out;
  RIPPLED_ZLIB_HOME = zlib.out;
  buildPhase = "scons build/rippled";

  installPhase = ''
    mkdir -p $out/bin    
    cp build/rippled $out/bin/
  '';

  meta = {
    description = "Ripple P2P payment network reference server";
    homepage = https://ripple.com;
    maintainers = [ stdenv.lib.maintainers.emery ];
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.linux;
  };
}
