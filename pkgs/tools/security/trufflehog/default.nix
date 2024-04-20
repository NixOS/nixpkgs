{
  lib,
  fetchFromGitHub,
  buildGoModule,
  testers,
  trufflehog,
}:

buildGoModule rec {
  pname = "trufflehog";
  version = "3.73.0";

  src = fetchFromGitHub {
    owner = "trufflesecurity";
    repo = "trufflehog";
    rev = "refs/tags/v${version}";
    hash = "sha256-5tyjSwuhrtiAzvS5F8TyPCZhjSasTWQE9wcNGDevucE=";
  };

  vendorHash = "sha256-eK4YwNkBvC7VW5Cn6/M4clN83LGRNuw5jpjtnM0B9g8=";

  proxyVendor = true;

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
    tests.version = testers.testVersion { package = trufflehog; };
  };

  meta = with lib; {
    description = "Find credentials all over the place";
    homepage = "https://github.com/trufflesecurity/trufflehog";
    changelog = "https://github.com/trufflesecurity/trufflehog/releases/tag/v${version}";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
