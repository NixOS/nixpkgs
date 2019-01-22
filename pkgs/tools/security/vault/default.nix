{ stdenv, fetchFromGitHub, go, gox, removeReferencesTo }:

stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "1nrqwgxfs6n2bjhjndqvwzn9c62pb5ky9biyh47i0wvbxhdh0hfj";
  };

  nativeBuildInputs = [ go gox removeReferencesTo ];

  preBuild = ''
    patchShebangs ./
    substituteInPlace scripts/build.sh --replace 'git rev-parse HEAD' 'echo ${src.rev}'
    sed -i s/'^GIT_DIRTY=.*'/'GIT_DIRTY="+NixOS"'/ scripts/build.sh

    mkdir -p .git/hooks src/github.com/hashicorp
    ln -s $(pwd) src/github.com/hashicorp/vault

    export GOPATH=$(pwd)
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/bash-completion/completions

    cp pkg/*/* $out/bin/
    find $out/bin -type f -exec remove-references-to -t ${go} '{}' +

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
