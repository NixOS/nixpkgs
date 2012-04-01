{ stdenv, fetchurl, scons, which, boost, gnutar, v8 ? null, useV8 ? false}:

assert useV8 -> v8 != null;

stdenv.mkDerivation rec {
  name = "mongodb-2.0.4";

  src = fetchurl {
    url = "http://downloads.mongodb.org/src/mongodb-src-r2.0.4.tar.gz";
    sha256 = "1y9qd94qfrp7h1mng7f8hfb36wgj93886d2ifadg8y3pfzr6sab5";
  };

  buildInputs = [scons which boost] ++ stdenv.lib.optional useV8 v8;

  enableParallelBuilding = true;

  patchPhase = ''
    substituteInPlace SConstruct --replace "Environment( MSVS_ARCH=msarch , tools = [\"default\", \"gch\"], toolpath = '.' )" "Environment( MSVS_ARCH=msarch , tools = [\"default\", \"gch\"], toolpath = '.', ENV = os.environ )"
    substituteInPlace SConstruct --replace "../v8" "${v8}"
    substituteInPlace SConstruct --replace "LIBPATH=[\"${v8}/\"]" "LIBPATH=[\"${v8}/lib\"]"
  '';

  buildPhase = ''
    export TERM=""
    scons all --cc=`which gcc` --cxx=`which g++` --libpath=${boost}/lib --cpppath=${boost}/include ${if useV8 then "--usev8" else ""}
  '';

  installPhase = ''
    scons install --cc=`which gcc` --cxx=`which g++` --libpath=${boost}/lib --cpppath=${boost}/include --full --prefix=$out
    if [ -d $out/lib64 ]; then
      mv $out/lib64 $out/lib
    fi
  '';

  meta = {
    description = "a scalable, high-performance, open source NoSQL database";
    homepage = http://www.mongodb.org;
    license = "AGPLv3";

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.all;
  };
}

