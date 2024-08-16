{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.20.3";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-q1wyyzkqEMEYmgmj11YaZYl3lTtJKfPM8fxjTmh7cT4=";
  };

  vendorHash = "sha256-Vi6eEQR3DQupn3CnasKxknaSk7Hs7C7v2yUGtxhsovQ=";

  ldflags = [ "-s" "-w" "-X info.Version=${version}" ];

  subPackages = [ "cmd/fission-cli" ];

  postInstall = ''
    ln -s $out/bin/fission-cli $out/bin/fission
  '';

  meta = with lib; {
    description = "Cli used by end user to interact Fission";
    homepage = "https://fission.io";
    license = licenses.asl20;
    maintainers = with maintainers; [ neverbehave ];
  };
}
