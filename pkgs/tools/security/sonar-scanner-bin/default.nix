{ stdenv, lib, fetchurl, unzip, jre }:

let

  version = "3.3.0.1492";

  sonarScannerArchPackage = {
    "x86_64-linux" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-linux.zip";
      sha256 = "1vn22d1i14440wlym0kxzbmjlxd9x9b0wc2ifm8fwig1xvnwpjwd";
    };
    "x86_64-darwin" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-macosx.zip";
      sha256 = "1m7cplak63m2rmad7f2s1iksi1qn43m2h1jm0qh3m219xcpl632i";
    };
  };

in stdenv.mkDerivation rec {
  inherit version;
  name = "sonar-scanner-bin-${version}";

  src = fetchurl sonarScannerArchPackage.${stdenv.hostPlatform.system};

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/lib
    cp -r lib/* $out/lib/
    mkdir -p $out/bin
    cp bin/* $out/bin/
    mkdir -p $out/conf
    cp conf/* $out/conf/
  '';

  fixupPhase = ''
    substituteInPlace $out/bin/sonar-scanner \
      --replace "\$sonar_scanner_home/jre" "${lib.getBin jre}"
  '';

  meta = with lib; {
    homepage = https://github.com/SonarSource/sonar-scanner-cli;
    description = "SonarQube Scanner used to start code analysis";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterromfeldhk ];
    platforms = builtins.attrNames sonarScannerArchPackage;
  };
}
