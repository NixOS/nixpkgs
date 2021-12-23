{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gitleaks";
  version = "8.2.4";

  src = fetchFromGitHub {
    owner = "zricethezav";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-74qNVW4NUGK16rZ3S7vxJ9Akci6ARcf4So1MydZVY3s=";
  };

  vendorSha256 = "sha256-cIwte59AdVOWMBUWE4gKZSHhU37HgEW4k0v+jUUyj1Q=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/zricethezav/gitleaks/v${lib.versions.major version}/version.Version=${version}"
  ];

  # With v8 the config tests are are blocking
  doCheck = false;

  meta = with lib; {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/zricethezav/gitleaks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
