{ stdenv, lib, fetchurl, unzip, jre }:

let

  version = "6.1.0.4477";

  sonarScannerArchPackage = {
    "x86_64-linux" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-linux-x64.zip";
    # TODO: fix checksums
      sha256 = "0qy97lcn9nfwg0x32v9x5kh5jswnjyw3wpvxj45z7cddlj2is4iy";
    };
    "aarch64-linux" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-linux-aarch64.zip";
      # TODO: fix checksums
      sha256 = "0qy97lcn9nfwg0x32v9x5kh5jswnjyw3wpvxj45z7cddlj2is4iy";
    };
    "x86_64-darwin" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-macosx-x64.zip";
      sha256 = "e7NRbIF27HvkOYLgy3jBzkYnQa2c4JIDfhKy/IQR64U=";
    };
    "aarch64-darwin" = {
      url = "https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${version}-macosx-aarch64.zip";
      sha256 = "fH5pts9U46X/Z6CBmdVX6Jb1G8ybL49fI4pao1llNlk=";
    };
  };

in stdenv.mkDerivation {
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

  passthru.tests = {
    # TODO: add tests
  };

  meta = with lib; {
    homepage = "https://github.com/SonarSource/sonar-scanner-cli";
    description = "SonarQube Scanner used to start code analysis";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ peterromfeldhk ];
    platforms = builtins.attrNames sonarScannerArchPackage;
  };
}
