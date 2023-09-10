{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "f2";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "ayoisaiah";
    repo = "f2";
    rev = "v${version}";
    sha256 = "sha256-vpyI6WtK/0UpPiB8y+HpPd0IsKKkMHa/eIreYo32iAA=";
  };

  vendorHash = "sha256-Bz3Igjcyq4rkMkgv1J3+JiAqroAjxyAvHw4d4eZJgAM=";

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
