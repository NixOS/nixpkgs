{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, libpcap
}:

buildGoModule rec {
  pname = "dnsmonster";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "mosajjal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-MiFwGVvaShy7dEKixIXdRCBmRc2YnxX49/7R8JugXng=";
  };

  vendorSha256 = "sha256-ZCtxKMD9hESERcsptdhxdV51nxyvrdj+guTodn/Sqao=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mosajjal/dnsmonster/util.releaseVersion=${version}"
  ];

  meta = with lib; {
    description = "Passive DNS Capture and Monitoring Toolkit";
    homepage = "https://github.com/mosajjal/dnsmonster";
    changelog = "https://github.com/mosajjal/dnsmonster/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fab ];
    broken = stdenv.isDarwin;
  };
}
