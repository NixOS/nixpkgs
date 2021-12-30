{ lib
, buildGoModule
, fetchFromGitHub
, log4j-vuln-scanner
, testVersion
}:

buildGoModule rec {
  pname = "log4j-vuln-scanner";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "hillu";
    repo = "local-log4j-vuln-scanner";
    rev = "v${version}";
    sha256 = "sha256-YGo2dhfqLPNP8O9gdRJfxKmEK/pKd17WNTXQ2cq78qg=";
  };

  vendorSha256 = null;

  postInstall = ''
    mv $out/bin/scanner $out/bin/$pname
    mv $out/bin/patcher $out/bin/log4j-vuln-patcher
  '';

  passthru.tests.version = testVersion { package = log4j-vuln-scanner; };

  meta = with lib; {
    description = "Local log4j vulnerability scanner";
    homepage = "https://github.com/hillu/local-log4j-vuln-scanner";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
