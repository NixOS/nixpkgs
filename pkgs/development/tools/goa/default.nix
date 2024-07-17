{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "goa";
  version = "3.16.2";

  src = fetchFromGitHub {
    owner = "goadesign";
    repo = "goa";
    rev = "v${version}";
    hash = "sha256-HDGopedI0kI6S7/EqHHyBUJKx25M+0tN/kIBC6Z4NYU=";
  };
  vendorHash = "sha256-H1hGZsDitamDDO0BNYjkLR4eIL0NFmpQHvMblNVLBho=";

  subPackages = [ "cmd/goa" ];

  meta = with lib; {
    description = "Design-based APIs and microservices in Go";
    mainProgram = "goa";
    homepage = "https://goa.design";
    license = licenses.mit;
    maintainers = with maintainers; [ rushmorem ];
  };
}
