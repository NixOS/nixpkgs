{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "fioctl";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "foundriesio";
    repo = "fioctl";
    rev = "v${version}";
    sha256 = "1jbj2w2s78wcnrwyr80jyc11ipjysv5aab3486kphx8ysvvgcwfs";
  };

  vendorSha256 = "1a3x6cv18f0n01f4ac1kprzmby8dphygnwsdl98pmzs3gqqnh284";

  runVend = true;

  buildFlagsArray = ''
    -ldflags=-s -w -X github.com/foundriesio/fioctl/subcommands/version.Commit=${src.rev}
  '';

  meta = with lib; {
    description = "A simple CLI to manage your Foundries Factory ";
    homepage = "https://github.com/foundriesio/fioctl";
    license = licenses.asl20;
    maintainers = with maintainers; [ nixinator matthewcroughan ];
  };
}
