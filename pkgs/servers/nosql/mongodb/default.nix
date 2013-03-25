{ stdenv, fetchurl, scons, which, v8}:

with stdenv.lib;

let installerPatch = fetchurl {
      url = "https://jira.mongodb.org/secure/attachment/18160/SConscript.client.patch";
      sha256 = "0n60fh2r8i7m6g113k0iw4adc8jv2by4ahrd780kxg47kzfgw06a";
    };

in
stdenv.mkDerivation rec {
  name = "mongodb-2.4.0";

  src = fetchurl {
    url = http://downloads.mongodb.org/src/mongodb-src-r2.4.0.tar.gz;
    sha256 = "115wrw23naxpaiwh8ar6g40f2nsdbz1hdpkp88wbi5yc9m6drg41";
  };

  nativeBuildInputs = [ scons which ];

  patches = [ installerPatch ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace SConstruct --replace "Environment( BUILD_DIR" "Environment( ENV = os.environ, BUILD_DIR"
    substituteInPlace SConstruct --replace "#/../v8" "${v8}" \
                                 --replace "[\"${v8}/\"]" "[\"${v8}/lib\"]"
  '';

  buildPhase = ''
    echo $PATH
    scons all --cc=`which gcc` --cxx=`which g++`
  '';

  installPhase = ''
    scons install --cc=`which gcc` --cxx=`which g++` --full --prefix=$out
    rm -rf $out/lib64 # exact same files as installed in $out/lib
  '';

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = "AGPLv3";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
