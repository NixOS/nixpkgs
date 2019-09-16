{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "11zi12j09vi6j112a1n8f7sxwp15pbh0801bzh27ihcy01hlzdf8";
  };

  modSha256 = "10pr3piv6hrsc562qagpn1h5wckiziyfqraj13172hdglz3n2i7q";

  buildFlagsArray = [
    "-tags='vault'"
    "-ldflags=\"-X github.com/hashicorp/vault/sdk/version.GitCommit='v${version}'\""
  ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/vault vault" > $out/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri ];
  };
}
