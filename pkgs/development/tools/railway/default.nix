{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "railway";
  version = "2.0.8";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    sha256 = "sha256-E6DCY+xM796pQb48xkVQ6d3qgIB528hbCU96SCu2eYI=";
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
