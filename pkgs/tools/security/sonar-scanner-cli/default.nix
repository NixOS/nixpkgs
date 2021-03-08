{ stdenv, lib, fetchurl, unzip, jre }:

let

  version = "4.5.0.2216";

  sonarScannerArchPackage = {
    "x86_64-linux" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-linux.zip";
      sha256 = "sha256-rmvDb5l2BGV8j94Uhu2kJXwoDAHA3VncAahqGvLY3I0=";
    };
    "x86_64-darwin" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-macosx.zip";
      sha256 = "1g3lldpkrjlvwld9h82hlwclyplxpbk4q3nq59ylw4dhp26kb993";
    };
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "sonar-scanner-cli";

  src = fetchurl sonarScannerArchPackage.${stdenv.hostPlatform.system};

  nativeBuildInputs = [ unzip ];

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
    homepage = "https://github.com/SonarSource/sonar-scanner-cli";
    description = "SonarQube Scanner used to start code analysis";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterromfeldhk ];
    platforms = builtins.attrNames sonarScannerArchPackage;
  };
}
