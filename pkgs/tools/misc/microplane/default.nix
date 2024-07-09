{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "microplane";
  version = "0.0.34";

  src = fetchFromGitHub {
    owner = "Clever";
    repo = "microplane";
    rev = "v${version}";
    sha256 = "sha256-ZrBkVXRGZp8yGFIBo7sLGvJ8pMQq7Cq0xJiko57z164=";
  };

  vendorHash = "sha256-PqSjSFTVrIsQ065blIxZ9H/ARku6BEcnjboH+0K0G14=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  postInstall = ''
    ln -s $out/bin/microplane $out/bin/mp
  '';

  meta = with lib; {
    description = "CLI tool to make git changes across many repos";
    homepage = "https://github.com/Clever/microplane";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
