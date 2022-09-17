{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "9.3.1";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dVHf6nm7IRMpZ8Tx4VxRfBb8HOEfWc/5LgWZQ5LDbuk=";
  };

  vendorSha256 = "sha256-A4+sshIzPla7udHfnMmbFqn+fW3SOCrI6g7tArzmh1E=";

  sourceRoot = "source/src";

  ldflags = [ "-s" "-w" "-X" "main.Version=${version}" ];

  meta = with lib; {
    description = "A prompt theme engine for any shell";
    homepage = "https://ohmyposh.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ lucperkins ];
  };
}
