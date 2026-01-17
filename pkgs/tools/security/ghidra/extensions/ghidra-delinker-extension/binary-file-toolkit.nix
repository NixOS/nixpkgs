{
  lib,
  fetchFromGitHub,
  maven,
}:
maven.buildMavenPackage rec {
  pname = "binary-file-toolkit";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "boricj";
    repo = "binary-file-toolkit";
    tag = "v${version}";
    hash = "sha256-ABDJDdx0OxXVOgYAw4kZAP3Psr+w7YevP1xk1RszXw8=";
  };

  mvnHash = "sha256-Ek2qulMSHd1ZJfEloo6fIe+QMqub/Ftna/TzTt01ky8=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/
    cp dist/* $out/

    runHook postInstall
  '';

  meta = {
    description = "Set of Java libraries for manipulating toolchain file formats";
    homepage = "https://github.com/boricj/binary-file-toolkit";
    changelog = "https://github.com/boricj/binary-file-toolkit/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timschumi ];
  };
}
