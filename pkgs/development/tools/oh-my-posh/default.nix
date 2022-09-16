{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oh-my-posh";
  version = "9.3.0";

  src = fetchFromGitHub {
    owner = "jandedobbeleer";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5VI7L6aGJcaqcNK0bNGv5Hb0YQxTfLFDcMmiWKTyzWA=";
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
