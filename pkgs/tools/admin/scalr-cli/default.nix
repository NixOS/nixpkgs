{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "scalr-cli";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "Scalr";
    repo = "scalr-cli";
    rev = "v${version}";
    hash = "sha256-8KhFF/bD//NYRQ7v+ksGAE6bKVu+nE3o3R119XbHVDA=";
  };

  vendorHash = "sha256-xoxSQ9V9i7yxJzn8wAtIAtWlTn4q/UnNqMT93RyBHII=";

  ldflags = [
    "-s" "-w"
  ];

  preConfigure = ''
    # Set the version.
    substituteInPlace main.go --replace '"0.0.0"' '"${version}"'
  '';

  postInstall = ''
    mv $out/bin/cli $out/bin/scalr
  '';

  doCheck = false; # Skip tests as they require creating actual Scalr resources.

  meta = with lib; {
    description = "A command-line tool that communicates directly with the Scalr API.";
    homepage = "https://github.com/Scalr/scalr-cli";
    changelog = "https://github.com/Scalr/scalr-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dylanmtaylor ];
    mainProgram = "scalr";
  };
}
