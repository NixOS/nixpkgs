{ stdenv, fetchzip, jdk, makeWrapper, installShellFiles }:

stdenv.mkDerivation rec {
  pname = "spring-boot";
  version = "2.1.9";

  src = fetchzip {
    url = "https://repo.spring.io/release/org/springframework/boot/${pname}-cli/${version}.RELEASE/${pname}-cli-${version}.RELEASE-bin.zip";
    sha256 = "03iphh5l9w9sizksidkv217qnqx3nh1zpw6kdjnn40j3mlabfb7j";
  };

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  installPhase = ''
    runHook preInstall
    rm bin/spring.bat
    installShellCompletion --bash shell-completion/bash/spring
    installShellCompletion --zsh shell-completion/zsh/_spring
    rm -r shell-completion
    cp -r . $out
    wrapProgram $out/bin/spring \
      --prefix JAVA_HOME : ${jdk}
    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = ''
      CLI which makes it easy to create spring-based applications
    '';
    longDescription = ''
      Spring Boot makes it easy to create stand-alone, production-grade 
      Spring-based Applications that you can run. We take an opinionated view 
      of the Spring platform and third-party libraries, so that you can get 
      started with minimum fuss. Most Spring Boot applications need very 
      little Spring configuration.

      You can use Spring Boot to create Java applications that can be started 
      by using java -jar or more traditional war deployments. We also provide 
      a command line tool that runs “spring scripts”.
    '';
    homepage = https://spring.io/projects/spring-boot;
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
