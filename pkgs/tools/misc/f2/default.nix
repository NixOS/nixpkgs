{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "f2";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-2+wp9hbPDH8RAeQNH1OYDfFlev+QTsEHixYb/luR9F0=";
  };

  vendorHash = "sha256-sOTdP+MuOH9jB3RMajeUx84pINSuWVRw5p/9lrOj6uo=";

  ldflags = [ "-s" "-w" "-X=main.Version=${version}" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Command-line batch renaming tool";
    homepage = "https://github.com/ayoisaiah/f2";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
