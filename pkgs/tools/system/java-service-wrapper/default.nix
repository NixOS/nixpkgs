{ lib, stdenv, fetchurl
, jdk
, ant, cunit, ncurses
}:

stdenv.mkDerivation rec {
  pname = "java-service-wrapper";
  version = "3.5.45";

  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${version}/wrapper_${version}_src.tar.gz";
    sha256 = "sha256-rnlloa0DicWT1RlP2szDvBINvT5/RZ17GOarUzvX1AI=";
  };

  buildInputs = [ jdk ];
  nativeBuildInputs = [ ant cunit ncurses ];

  buildPhase = ''
    export ANT_HOME=${ant}
    export JAVA_HOME=${jdk}/lib/openjdk/jre/
    export JAVA_TOOL_OPTIONS=-Djava.home=$JAVA_HOME
    export CLASSPATH=${jdk}/lib/openjdk/lib/tools.jar

    ${if stdenv.isi686 then "./build32.sh" else "./build64.sh"}
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp bin/wrapper $out/bin/wrapper
    cp lib/wrapper.jar $out/lib/wrapper.jar
    cp lib/libwrapper.so $out/lib/libwrapper.so
  '';

  meta = with lib; {
    description = "Enables a Java Application to be run as a Windows Service or Unix Daemon";
    homepage = "https://wrapper.tanukisoftware.com/";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.suhr ];
  };
}
