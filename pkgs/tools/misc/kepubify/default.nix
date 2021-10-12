{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "kepubify";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "pgaskin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZQY5U9uMCwsMl3Ds3bscPYmTt8JdWehOoowb+AmJSbQ=";
  };

  vendorSha256 = "sha256-DcE2MCbH5FIU1UoIF8OF17TfsWS5eQhHnWDEAxy8X6c=";

  # remove when built with >= go 1.17
  tags = [ "zip117" ];

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = [ "kobotest" ];

  meta = with lib; {
    description = "EPUB to KEPUB converter";
    homepage = "https://pgaskin.net/kepubify";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
