{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools, python }:
with stdenv.lib;
stdenv.mkDerivation rec {
  name = "opentsdb-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "https://github.com/OpenTSDB/opentsdb/releases/download/${version}/opentsdb-${version}.tar.gz";
    sha256 = "17wbdvrv83dr18dqxxsk73c1a7jlbw19algvz0hsz9a1k7aiy29b";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python ];

  configurePhase = ''
    echo > build-aux/fetchdep.sh.in
    ./bootstrap
    mkdir build
    cd build
    ../configure --prefix=$out
    patchShebangs ../build-aux/
  '';

  installPhase = ''
    make install
    wrapProgram $out/bin/tsdb \
      --set JAVA_HOME "${jre}" \
      --set JAVA "${jre}/bin/java"
  '';

  meta = with stdenv.lib; {
    description = "Time series database with millisecond precision";
    homepage = http://opentsdb.net;
    license = licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ maintainers.ocharles ];
  };
}
