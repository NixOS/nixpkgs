{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "fission";
  version = "1.20.2";

  src = fetchFromGitHub {
    owner = "fission";
    repo = "fission";
    rev = "v${version}";
    hash = "sha256-DkSilNn98m7E9qTRpf+g2cmo3SHeJkW4eJ5T6XQM3S8=";
  };

  vendorHash = "sha256-IChr8jC21yI5zOkHF2v9lQoqXT95FSMXJdWj7HqikB4=";

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
