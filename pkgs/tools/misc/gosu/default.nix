{ lib, buildGoModule, fetchFromGitHub, testers, gosu }:

buildGoModule rec {
  pname = "gosu";
  version = "1.16";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = version;
    hash = "sha256-UfrhrwsnDT7pfizQtQzqv/1FTMBTrk3qmtiR7ffwwhc=";
  };

  vendorHash = "sha256-3HIAPI1bbfwE2/cUsQnp2Vz2uvlvSFDUrp2xuGNr8Gk=";

  ldflags = [ "-d" "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = gosu;
  };

  meta = with lib; {
    description = "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    homepage = "https://github.com/tianon/gosu";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.linux;
  };
}
