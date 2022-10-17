{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "act";
  version = "0.2.32";

  src = fetchFromGitHub {
    owner = "nektos";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fHGS05qlRSVTrjEx71hhVridbpbLVyaAOg3uMYIj0TU=";
  };

  vendorSha256 = "sha256-ctIKaThBIzaBw3/a0pat+G7Zb4Y2F7mk8VZWoM0XdyI=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    description = "Run your GitHub Actions locally";
    homepage = "https://github.com/nektos/act";
    changelog = "https://github.com/nektos/act/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne SuperSandro2000 ];
  };
}
