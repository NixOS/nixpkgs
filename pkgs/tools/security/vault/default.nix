{ stdenv, fetchFromGitHub, go, gox, removeReferencesTo }:

stdenv.mkDerivation rec {
  name = "vault-${version}";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "vault";
    rev = "v${version}";
    sha256 = "0dylwvs95crvn1p7pbyzib979rxzp4ivzvi5k4f5ivp4ygnp597s";
  };

  nativeBuildInputs = [ go gox removeReferencesTo ];

  preBuild = ''
    patchShebangs ./
    substituteInPlace scripts/build.sh --replace 'git rev-parse HEAD' 'echo ${src.rev}'
    sed -i s/'^GIT_DIRTY=.*'/'GIT_DIRTY="+NixOS"'/ scripts/build.sh

    mkdir -p .git/hooks src/github.com/hashicorp
    ln -s $(pwd) src/github.com/hashicorp/vault

    export GOPATH=$(pwd)
    export GOCACHE="$TMPDIR/go-cache"
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
