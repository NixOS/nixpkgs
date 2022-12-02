{ lib, buildGoModule, fetchFromGitHub, testers, gosu }:

buildGoModule rec {
  pname = "gosu";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    sha256 = "sha256-qwoHQB37tY8Pz8CHleYZI+SGkbHG7P/vgfXVMSyqi10=";
  };

  vendorSha256 = "sha256-yxrOLCtSrY/a84N5yRWGUx1L425TckjvRyn/rtkzsRY=";

  ldflags = [ "-d" "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gosu;
  };

  meta = with lib; {
    description = "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    homepage = "https://github.com/tianon/gosu";
    license = lib.licenses.gpl3;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux;
  };
}
