{ stdenv, fetchurl, scons, boost, v8, gperftools, pcre, snappy }:

let version = "2.4.8"; in stdenv.mkDerivation rec {
  name = "mongodb-${version}";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r${version}.tar.gz";
    sha256 = "1p6gnharypglfp39halp72fig96fqjhakyy7m76a1prxwpjkqw7x";
  };

  nativeBuildInputs = [ scons boost v8 gperftools pcre snappy ];

  postPatch = ''
    substituteInPlace SConstruct \
        --replace "Environment( BUILD_DIR" "Environment( ENV = os.environ, BUILD_DIR" \
        --replace 'CCFLAGS=["-Werror", "-pipe"]' 'CCFLAGS=["-pipe"]'
  '';

  buildPhase = ''
    export SCONSFLAGS="-j$NIX_BUILD_CORES"
    scons all --use-system-all
  '';

  installPhase = ''
    mkdir -p $out/lib
    scons install --use-system-all --full --prefix=$out
  '';

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = "AGPLv3";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
