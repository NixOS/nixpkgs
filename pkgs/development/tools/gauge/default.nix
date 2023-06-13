{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gauge";
  version = "1.4.3";

  excludedPackages = [ "build" "man" ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    rev = "v${version}";
    sha256 = "sha256-TszZAREk6Hs2jULjftQAhHRIVKaZ8fw0NLJkBdr0FPw=";
  };

  vendorSha256 = "1wp19m5n85c7lsv8rvcbfz1bv4zhhb7dj1frkdh14cqx70s33q8r";

  meta = with lib; {
    description = "Light weight cross-platform test automation";
    homepage = "https://gauge.org";
    license = licenses.asl20;
    maintainers = [ maintainers.vdemeester ];
  };
}
