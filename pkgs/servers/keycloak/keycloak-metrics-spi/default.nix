<<<<<<< HEAD
{ maven, lib, fetchFromGitHub }:

maven.buildMavenPackage rec {
  pname = "keycloak-metrics-spi";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "aerogear";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-pacmx5w1VVWz3HmHO6sc2friNUpzo4zyJI1/TQgCXlc=";
  };

  mvnHash = "sha256-rwAc2KtKo4vJ0JWwPquMyt+FHVNTmMpzBPbo8lWDN/A=";

  installPhase = ''
    runHook preInstall
    install -Dm444 -t "$out" target/keycloak-metrics-spi-*.jar
    runHook postInstall
=======
{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  pname = "keycloak-metrics-spi";
  version = "2.5.3";

  src = fetchurl {
    url = "https://github.com/aerogear/keycloak-metrics-spi/releases/download/${version}/keycloak-metrics-spi-${version}.jar";
    sha256 = "15lsy8wjw6nlfdfhllc45z9l5474p0lsghrwzzsssvd68bw54gwv";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    install "$src" "$out"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  meta = with lib; {
    homepage = "https://github.com/aerogear/keycloak-metrics-spi";
    description = "Keycloak Service Provider that adds a metrics endpoint";
<<<<<<< HEAD
    license = licenses.asl20;
=======
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.apsl20;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    maintainers = with maintainers; [ benley ];
  };
}
