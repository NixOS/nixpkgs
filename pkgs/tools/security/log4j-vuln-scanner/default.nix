{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "log4j-vuln-scanner";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "hillu";
    repo = "local-log4j-vuln-scanner";
    rev = "v${version}";
    sha256 = "sha256-YMD2233EdrrF1SLjwiRcNr53b7Rf5Tu8CZC43QhSY7c=";
  };

  vendorSha256 = null;

  postInstall = ''
    mv $out/bin/scanner $out/bin/$pname
    mv $out/bin/patcher $out/bin/log4j-vuln-patcher
  '';

  meta = with lib; {
    description = "Local log4j vulnerability scanner";
    homepage = "https://github.com/hillu/local-log4j-vuln-scanner";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
