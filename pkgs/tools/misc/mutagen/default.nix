{ lib, buildGoModule, fetchFromGitHub, fetchzip, installShellFiles }:

buildGoModule rec {
  pname = "mutagen";
  version = "0.17.6";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GkTMc+gS90M0Jx00nV8+QW/F2iBMmi/oNpwFun18yy4=";
  };

  vendorHash = "sha256-Bd2fI2p/8JNoN3Q3sJFuF83YyXUi5j68udW6QnVMViM=";

  agents = fetchzip {
    name = "mutagen-agents-${version}";
    # The package architecture does not matter since all packages contain identical mutagen-agents.tar.gz.
    url = "https://github.com/mutagen-io/mutagen/releases/download/v${version}/mutagen_linux_amd64_v${version}.tar.gz";
    stripRoot = false;
    postFetch = ''
      rm $out/mutagen # Keep only mutagen-agents.tar.gz.
    '';
    hash = "sha256-0Oh5k2tKhQzlL8E6vWEMDyZ1JGw329K5E7Y8kam2Sec=";
  };

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [ "cmd/mutagen" "cmd/mutagen-agent" ];

  tags = [ "mutagencli" "mutagenagent" ];

  postInstall = ''
    install -d $out/libexec
    ln -s ${agents}/mutagen-agents.tar.gz $out/libexec/

    $out/bin/mutagen generate \
      --bash-completion-script mutagen.bash \
      --fish-completion-script mutagen.fish \
      --zsh-completion-script mutagen.zsh

    installShellCompletion \
      --cmd mutagen \
      --bash mutagen.bash \
      --fish mutagen.fish \
      --zsh mutagen.zsh
  '';

  meta = with lib; {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen/releases/tag/v${version}";
    maintainers = [ ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
  };
}
