{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "railway";
  version = "2.0.11";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-A8bfs8GgpsuX3QlJsjUWhgh0zXX0+HULRBQSY+lkXuE=";
  };

  ldflags = [ "-s" "-w" ];

  vendorSha256 = "sha256-nLuomuAScodgLUKzMTiygtFBnNHrqAojOySZgKLVGJY=";

  postInstall = ''
    mv $out/bin/cli $out/bin/railway
  '';

  meta = with lib; {
    description = "Railway CLI";
    homepage = "https://railway.app";
    license = licenses.mit;
    maintainers = with maintainers; [ Crafter ];
  };
}
