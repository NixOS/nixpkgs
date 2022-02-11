{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pe4jNBoPjrkvsdeFjH4TNwacp0qkf+v+SjIAZqV1GWE=";
  };

  vendorSha256 = "sha256-eiFG6lgsY5hf+XT3Kf5uA4Ai8vBbPsh1T4ObV+rj30Y=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
