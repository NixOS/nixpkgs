{ stdenv, fetchFromGitHub, go, gox, removeReferencesTo }:

let
  vaultBashCompletions = fetchFromGitHub {
    owner = "iljaweis";
    repo = "vault-bash-completion";
    rev = "e2f59b64be1fa5430fa05c91b6274284de4ea77c";
    sha256 = "10m75rp3hy71wlmnd88grmpjhqy0pwb9m8wm19l0f463xla54frd";
  };
in stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "15wj1pfgzwzjfrqy7b5bx4y9f0hbpqlfif58l5xamwm88229qk4m";
  };

  nativeBuildInputs = [ go gox removeReferencesTo ];

  buildPhase = ''
    substituteInPlace scripts/build.sh --replace 'git rev-parse HEAD' 'echo ${src.rev}'

    mkdir -p src/github.com/hashicorp
    ln -s $(pwd) src/github.com/hashicorp/vault

    GOPATH=$(pwd) make
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions

    cp pkg/*/* $out/bin/
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' +

    cp ${vaultBashCompletions}/vault-bash-completion.sh $out/share/bash-completion/completions/vault
  '';

  meta = with stdenv.lib; {
    homepage = https://www.vaultproject.io;
    description = "A tool for managing secrets";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.mpl20;
    maintainers = with maintainers; [ rushmorem offline pradeepchhetri ];
  };
}
