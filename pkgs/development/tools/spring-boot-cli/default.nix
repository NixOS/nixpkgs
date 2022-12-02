{ lib, stdenv, fetchzip, jdk, makeWrapper, installShellFiles, coreutils }:

stdenv.mkDerivation rec {
  pname = "spring-boot-cli";
  version = "2.3.2";

  src = fetchzip {
    url = "https://repo.spring.io/release/org/springframework/boot/${pname}/${version}.RELEASE/${pname}-${version}.RELEASE-bin.zip";
    sha256 = "1zqfnxz57234227rp303iwis0mjkkjkpcqnj9jgw78gykjnqdmmq";
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
      --set JAVA_HOME ${jdk} \
      --set PATH /bin:${coreutils}/bin:${jdk}/bin
    runHook postInstall
  '';

  meta = with lib; {
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
    homepage = "https://spring.io/projects/spring-boot";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
}
