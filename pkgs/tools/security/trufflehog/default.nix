{ lib
, fetchFromGitHub
, buildGoModule
, testers
, trufflehog
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.63.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-7heKPssACk6CI0O29U2astkwJAYk3a043l8Cqz6swMg=";
  };

  vendorHash = "sha256-+Boe/bzCsmihspGqmiJ3jOcRJ9KPjkzu6MBmgtAgwjE=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=${version}"
  ];

  # Test cases run git clone and require network access
  doCheck = false;

  postInstall = ''
    rm $out/bin/{generate,snifftest}
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = trufflehog;
    };
  };

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
