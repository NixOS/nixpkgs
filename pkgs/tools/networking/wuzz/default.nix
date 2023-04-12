{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wuzz";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "asciimoo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H0soiKOytchfcFx17az0pGoFbA+hhXLxGJVdaARvnDc=";
  };

  vendorSha256 = null; #vendorSha256 = "";

  meta = with lib; {
    homepage = "https://github.com/asciimoo/wuzz";
    description = "Interactive cli tool for HTTP inspection";
    license = licenses.agpl3;
    maintainers = with maintainers; [ pradeepchhetri ];
    broken = true; # vendor isn't reproducible with go > 1.17: nix-build -A $name.go-modules --check
  };
}
