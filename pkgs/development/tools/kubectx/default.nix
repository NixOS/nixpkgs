{ stdenv, lib, fetchFromGitHub, kubectl, makeWrapper }:

with lib;

stdenv.mkDerivation rec {
  pname = "kubectx";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "ahmetb";
    repo = pname;
    rev = "v${version}";
    sha256 = "0nb867llpvjmkxv5bbqnyjrc4z74kibqg1d3dw7m47d5a5hn8525";
  };

  buildInputs = [ makeWrapper ];

  dontBuild = true;
  doCheck = false;

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/zsh/site-functions
    mkdir -p $out/share/bash-completion/completions
    mkdir -p $out/share/fish/vendor_completions.d

    cp kubectx $out/bin
    cp kubens $out/bin

    # Provide ZSH completions
    cp completion/kubectx.zsh $out/share/zsh/site-functions/_kubectx
    cp completion/kubens.zsh $out/share/zsh/site-functions/_kubens

    # Provide BASH completions
    cp completion/kubectx.bash $out/share/bash-completion/completions/kubectx
    cp completion/kubens.bash $out/share/bash-completion/completions/kubens

    # Provide FISH completions
    cp completion/*.fish $out/share/fish/vendor_completions.d/

    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${makeBinPath [ kubectl ]}
    done
  '';

  meta = {
    description = "Fast way to switch between clusters and namespaces in kubectl!";
    license = licenses.asl20;
    homepage = https://github.com/ahmetb/kubectx;
    maintainers = with maintainers; [ periklis ];
    platforms = with platforms; unix;
  };
}
