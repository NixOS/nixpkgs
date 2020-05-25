{ stdenv, fetchzip, jdk, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "micronaut";
  version = "1.3.2";

  src = fetchzip {
    url = "https://github.com/micronaut-projects/micronaut-core/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "0jwvbymwaz4whw08n9scz6vk57sx7l3qddh4m5dlv2cxishwf7n3";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    rm bin/mn.bat
    cp -r . $out
    wrapProgram $out/bin/mn \
      --prefix JAVA_HOME : ${jdk} 
    installShellCompletion --bash --name mn.bash bin/mn_completion
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Modern, JVM-based, full-stack framework for building microservice applications";
    longDescription = ''
      Micronaut is a modern, JVM-based, full stack microservices framework
      designed for building modular, easily testable microservice applications.
      Reflection-based IoC frameworks load and cache reflection data for 
      every single field, method, and constructor in your code, whereas with 
      Micronaut, your application startup time and memory consumption are 
      not bound to the size of your codebase.
    '';
    homepage = "https://micronaut.io/";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
