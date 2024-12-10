{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.14";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+DdhdW8CCMprjR2XcOntkTDh5CHtEFHYFz7Htdptw3s=";
  };

  vendorHash = "sha256-4kBXVsKf1jD3zvaAy6Rb7zmIK1WPbi31GRvRghdEC/s=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      swdunlop
      derekcollison
    ];
  };
}
