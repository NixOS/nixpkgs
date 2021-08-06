{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "mmv-go";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "itchyny";
    repo = "mmv";
    rev = "v${version}";
    sha256 = "12k5zzyr0lhjadc9kza04v0zgb20v7m4syaqwc7qvn3kfvv1mz8s";
  };

  vendorSha256 = "0xnrai15ww9lfk02bc9p5ssycwnqkyjj5ch1srh7yvnbw3fakx68";

  ldflags = [ "-s" "-w" "-X main.revision=${src.rev}" ];

  meta = with lib; {
    homepage = "https://github.com/itchyny/mmv";
    description = "Rename multiple files using your $EDITOR";
    license = licenses.mit;
    maintainers = with maintainers; [ zowoq ];
  };
}
