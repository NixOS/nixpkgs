{ lib
, stdenv
, fetchurl
, jdk
, ant
, cunit
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "java-service-wrapper";
  version = "3.5.54";

  src = fetchurl {
    url = "https://wrapper.tanukisoftware.com/download/${version}/wrapper_${version}_src.tar.gz";
    hash = "sha256-t16i1WqvDqr4J5sDldeUk6+DAyN/6oWGV6eME5yj+i4=";
  };

  strictDeps = true;

  buildInputs = [ cunit ncurses ];

  nativeBuildInputs = [ ant jdk ];

  postConfigure = ''
    substituteInPlace default.properties \
      --replace "javac.target.version=1.4" "javac.target.version=8"
  '';

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME=${jdk}/lib/openjdk/
    export JAVA_TOOL_OPTIONS=-Djava.home=$JAVA_HOME
    export CLASSPATH=${jdk}/lib/openjdk/lib/tools.jar

    ant -f build.xml -Dbits=${if stdenv.isi686 then "32" else "64"}

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
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    maintainers = [ maintainers.suhr ];
    mainProgram = "wrapper";
  };
}
