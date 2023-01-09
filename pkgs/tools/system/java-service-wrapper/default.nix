{ lib, stdenv, fetchurl
, jdk
, ant, cunit, ncurses
}:

stdenv.mkDerivation rec {
  pname = "java-service-wrapper";
  version = "3.5.51";

  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${version}/wrapper_${version}_src.tar.gz";
    hash = "sha256-XkgzggtFLYCt3gP0F4wq38TFHCoo/x+bDzzz/TqmvB0=";
  };

  buildInputs = [ jdk ];
  nativeBuildInputs = [ ant cunit ncurses ];

  buildPhase = ''
    runHook preBuild

    export ANT_HOME=${ant}
    export JAVA_HOME=${jdk}/lib/openjdk/jre/
    export JAVA_TOOL_OPTIONS=-Djava.home=$JAVA_HOME
    export CLASSPATH=${jdk}/lib/openjdk/lib/tools.jar

    ${if stdenv.isi686 then "./build32.sh" else "./build64.sh"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp bin/wrapper $out/bin/wrapper
    cp lib/wrapper.jar $out/lib/wrapper.jar
    cp lib/libwrapper.so $out/lib/libwrapper.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Enables a Java Application to be run as a Windows Service or Unix Daemon";
    homepage = "https://wrapper.tanukisoftware.com/";
    changelog = "https://wrapper.tanukisoftware.com/doc/english/release-notes.html#${version}";
    license = licenses.gpl2Only;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = [ maintainers.suhr ];
  };
}
