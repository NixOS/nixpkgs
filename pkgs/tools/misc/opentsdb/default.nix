{ stdenv, autoconf, automake, curl, fetchurl, jdk, jre, makeWrapper, nettools
, python, git
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "opentsdb-${version}";
  version = "2.3.0";

  src = fetchurl {
    url = "https://github.com/OpenTSDB/opentsdb/releases/download/v${version}/${name}.tar.gz";
    sha256 = "0nip40rh3vl5azfc27yha4ngnm9sw47hf110c90hg0warzz85sch";
  };

  buildInputs = [ autoconf automake curl jdk makeWrapper nettools python git ];

  preConfigure = ''
    patchShebangs ./build-aux/
    ./bootstrap
  '';

  postInstall = ''
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
