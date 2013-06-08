{ stdenv, fetchurl, scons, boost, v8, gperftools, pcre, snappy }:

with stdenv.lib;

let installerPatch = fetchurl {
      url = "https://jira.mongodb.org/secure/attachment/18160/SConscript.client.patch";
      sha256 = "0n60fh2r8i7m6g113k0iw4adc8jv2by4ahrd780kxg47kzfgw06a";
    };

in
stdenv.mkDerivation rec {
  name = "mongodb-2.4.3";

  src = fetchurl {
    url = http://downloads.mongodb.org/src/mongodb-src-r2.4.3.tar.gz;
    sha256 = "1k653xmwphdk88z2byz5fglr8xcsm8nw13prls1rx16qnc6h1pb1";
  };

  nativeBuildInputs = [ scons boost v8 gperftools pcre snappy ];

  patches = [ installerPatch ];

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
