{ stdenv, fetchFromGitHub, buildGoPackage }:

buildGoPackage rec {
  pname = "vault";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "1akcfrxnsb37apsxblyigdcgca6ma7al23h654hplfs6vmq9aypi";
  };

  goPackagePath = "github.com/hashicorp/vault";

  subPackages = [ "." ];

  buildFlagsArray = [
    "-tags='vault'"
    "-ldflags=\"-X github.com/hashicorp/vault/sdk/version.GitCommit='v${version}'\""
  ];

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions
    echo "complete -C $bin/bin/vault vault" > $bin/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.vaultproject.io/";
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem lnl7 offline pradeepchhetri ];
  };
}
