{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nexttrace";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "sjlleo";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-sOTQBh6j8od24s36J0e2aKW1mWmAD/ThfY6pd1SsSlY=";
  };
  vendorHash = "sha256-ckGoDV4GNp0mG+bkCKoLBO+ap53R5zrq/ZSKiFmVf9U=";

  doCheck = false; # Tests require a network connection.

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xgadget-lab/nexttrace/printer.version=v${version}"
  ];

  meta = with lib; {
    description = "An open source visual route tracking CLI tool";
    homepage = "https://mtr.moe";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sharzy ];
  };
}

