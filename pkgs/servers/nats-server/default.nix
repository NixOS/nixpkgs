{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "nats-server";
  version = "2.10.10";

  src = fetchFromGitHub {
    owner = "nats-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9iV3zw0PtncI6eJNJlQ9cCAIFWA2w+sKk0kH7fpQyOo=";
  };

  vendorHash = "sha256-uhEjZcp3y+nFEChb2/Ac/eolOuJxF4WpAjKtXsfpRaw=";

  doCheck = false;

  passthru.tests.nats = nixosTests.nats;

  meta = with lib; {
    description = "High-Performance server for NATS";
    mainProgram = "nats-server";
    homepage = "https://nats.io/";
    changelog = "https://github.com/nats-io/nats-server/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ swdunlop derekcollison ];
  };
}
