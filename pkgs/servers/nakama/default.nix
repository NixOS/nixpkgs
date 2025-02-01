{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "nakama";
  version = "3.19.0"; # Update this to latest stable version

  src = fetchFromGitHub {
    owner = "heroiclabs";
    repo = "nakama";
    rev = "v${version}";
    hash = "sha256-x5gT/mYVaYdeor+U37z1MjJ6zmb7yep/2tVJYgGXPYo="; # Replace this with actual hash after first build attempt
  };

 vendorHash = null;

  # Only build the main server package
  subPackages = [ "." ];

  # Skip console UI and development tools
  excludedPackages = [
    "build"
    "console/openapi-gen-angular"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  # Nakama requires CockroachDB/Postgres for tests
  doCheck = false;

  # The console UI is embedded in the binary at build time
  preBuild = ''
    # Ensure the build directory exists
    mkdir -p build
  '';

  meta = with lib; {
    description = "Distributed server for social and realtime games and apps";
    homepage = "https://heroiclabs.com/nakama/";
    license = licenses.asl20;
    maintainers = with maintainers; [ /* add yourself here */ ];
    platforms = platforms.linux;
  };
}
