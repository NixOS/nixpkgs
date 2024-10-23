{ stdenv, lib, fetchzip, unzip, jre }:

stdenv.mkDerivation rec {
  pname = "sonar-scanner-cli";
  version = "6.1.0.4477";

  src = fetchzip {
    url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}.zip";
    sha256 = "sha256-af5B5YUS0qph+ZyVYzbI4GBFNweg2xOoZvfjd3Bmrag=";
  };

  nativeBuildInputs = [ unzip ];

  env.JAVA_HOME = lib.getBin jre;

  installPhase = ''
    mkdir -p $out/lib
    cp -r lib/* $out/lib/
    mkdir -p $out/bin
    cp bin/* $out/bin/
    mkdir -p $out/conf
    cp conf/* $out/conf/
  '';

  meta = with lib; {
    homepage = "https://github.com/SonarSource/sonar-scanner-cli";
    description = "SonarQube Scanner used to start code analysis";
    license = licenses.gpl3Plus;
    mainProgram = "sonar-scanner";
    maintainers = with maintainers; [ peterromfeldhk ];
    platforms = [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ];
  };
}
