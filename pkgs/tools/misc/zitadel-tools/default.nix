{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "zitadel-tools";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "zitadel";
    repo = "zitadel-tools";
    rev = "v${version}";
    hash = "sha256-yKSpWvv/xW7ID0KhPIsrZOEWuuhEqpJuiswqO71ooEw=";
  };

  vendorHash = "sha256-ZS8m3zjLWvX3kFty2jpObw+rfyozJ3yDfZBcFCdD96U=";

  ldflags = [
    "-s" "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Helper tools for zitadel";
    homepage = "https://github.com/zitadel/zitadel-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
  };
}
