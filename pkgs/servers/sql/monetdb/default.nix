{ composableDerivation, fetchurl, pcre, openssl, readline, libxml2, geos, apacheAnt, jdk5 }:

let inherit (composableDerivation) edf; in

composableDerivation.composableDerivation {} {

  name = "monetdb-2009-05-01";

  src = fetchurl {
    url = http://monetdb.cwi.nl/downloads/sources/May2009-SP1/MonetDB-May2009-SuperBall-SP1.tar.bz2;
    sha256 = "0r794snnwa4m0x57nv8cgfdxwb689946c1mi2s44wp4iljka2ryj";
  };

  flags = edf { name = "geom"; enable = { buildInputs = [geos]; }; }
          // {
            java = { buildInputs = [ (apacheAnt.override {jdk = jdk5;}) jdk5 /* must be 1.5 */ ]; };
            /* perl TODO export these (SWIG only if its present) HAVE_PERL=1 HAVE_PERL_DEVEL=1 HAVE_PERL_SWIG=1 */
          };

  buildInputs = [ pcre
                   openssl readline libxml2 ]; # optional python perl php java ?

  cfg = {
    geomSupport = true;
    javaSupport = true;
  };

  dontBuild = true;

  installPhase = ''
    mkdir $TMP/build
    sh monetdb-install.sh --build=$TMP/build --prefix=$out --enable-sql --enable-xquery
  '';

  meta = {
    description = "A open-source database system for high-performance applications in data mining, OLAP, GIS, XML Query, text and multimedia retrieval";
    homepage = http://monetdb.cwi.nl/;
    license = "MonetDB Public License"; # very similar to Mozilla public license (MPL) Version see 1.1 http://monetdb.cwi.nl/Legal/MonetDBLicense-1.1.html 
  };
}
