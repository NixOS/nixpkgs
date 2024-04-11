{ stdenv, lib, fetchurl, unzip, jre }:

let

  version = "4.7.0.2747";

  sonarScannerArchPackage = {
    "x86_64-linux" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-linux.zip";
      sha256 = "0qy97lcn9nfwg0x32v9x5kh5jswnjyw3wpvxj45z7cddlj2is4iy";
    };
    "x86_64-darwin" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-macosx.zip";
      sha256 = "0f8km7wqkw09g01l03kcrjgvq7b6xclzpvb5r64ymsmrc39p0ylp";
    };
  };

in stdenv.mkDerivation rec {
  inherit version;
  pname = "sonar-scanner-cli";

  src = fetchurl sonarScannerArchPackage.${stdenv.hostPlatform.system} or (throw "unsupported system ${stdenv.hostPlatform.system}");

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
