{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "railway";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-g/QBsWWVjhmn5slNav7j+vrzwf/0mMAERJaDLRrbxGI=";
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
