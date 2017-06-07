{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

let
  vaultBashCompletions = fetchFromGitHub {
    owner = "iljaweis";
    repo = "vault-bash-completion";
    rev = "e2f59b64be1fa5430fa05c91b6274284de4ea77c";
    sha256 = "10m75rp3hy71wlmnd88grmpjhqy0pwb9m8wm19l0f463xla54frd";
  };
in buildGoPackage rec {
  name = "vault-${version}";
  version = "0.7.2";

  goPackagePath = "github.com/hashicorp/vault";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "1kclpyb9a9y5zjvrlbxnkac4fl3lwqsr98v4yydf9ihl5v7wy4f5";
  };

  buildFlagsArray = ''
    -ldflags=
      -X github.com/hashicorp/vault/version.GitCommit=${version}
  '';

  postInstall = ''
    mkdir -p $bin/share/bash-completion/completions/
    cp ${vaultBashCompletions}/vault-bash-completion.sh $bin/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem offline pradeepchhetri ];
  };
}
