{ lib, stdenv, fetchzip, jdk, makeWrapper, installShellFiles, coreutils, testers, gitUpdater }:

stdenv.mkDerivation (finalAttrs: {
  pname = "spring-boot-cli";
  version = "3.3.0";

  src = fetchzip {
    url = "mirror://maven/org/springframework/boot/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}-bin.zip";
    hash = "sha256-dTTTcmR4C9UiYEfiKHr0sJBtHg/+sJcGIdrXSOoK1mw=";
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

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "${lib.getExe finalAttrs.finalPackage} --version";
      version = "v${finalAttrs.version}";
    };
    updateScript = gitUpdater {
      url = "https://github.com/spring-projects/spring-boot";
      ignoredVersions = ".*-(RC|M).*";
      rev-prefix = "v";
    };
  };

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
    changelog = "https://github.com/spring-projects/spring-boot/releases/tag/v${finalAttrs.version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    mainProgram = "spring";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ moaxcp ];
  };
})
