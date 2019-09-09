{ stdenv, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "vault";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "1xljm7xmb4ldg3wx8s9kw1spffg4ywk4r1jqfa743czd2xxmqavl";
  };

  modSha256 = "13pr3piv6hrsc562qagpn1h5wckiziyfqraj13172hdglz3n2i7q";

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
