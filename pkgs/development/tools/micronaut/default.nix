{ stdenv, fetchzip, jdk, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "micronaut";
  version = "1.2.3";

  src = fetchzip {
    url = "https://github.com/micronaut-projects/micronaut-core/releases/download/v${version}/${pname}-${version}.zip";
    sha256 = "0lfl2hfakpdcfii3a3jr6kws731jamy4fb3dmlnj5ydk0zbnmk6r";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    rm bin/mn.bat
    cp -r . $out
    wrapProgram $out/bin/mn \
      --prefix JAVA_HOME : ${jdk} 
    installShellCompletion --bash --name mn.bash bin/mn_completion
  '';

  meta = with stdenv.lib; {
    description = ''
      A modern, JVM-based, full-stack framework for building modular, 
      easily testable microservice and serverless applications.
    '';
    longDescription = ''
      Reflection-based IoC frameworks load and cache reflection data for 
      every single field, method, and constructor in your code, whereas with 
      Micronaut, your application startup time and memory consumption are 
      not bound to the size of your codebase.
    '';
    homepage = https://micronaut.io/;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
