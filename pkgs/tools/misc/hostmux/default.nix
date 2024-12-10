{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  openssh,
  tmux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hostmux";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "hukl";
    repo = "hostmux";
    rev = finalAttrs.version;
    hash = "sha256-odN7QFsU3MsWW8VabVjZH+8+AUFOUio8eF9ORv9iPEA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    openssh
    tmux
  ];

  postPatch = ''
    substituteInPlace hostmux \
      --replace "SSH_CMD=ssh" "SSH_CMD=${openssh}/bin/ssh" \
      --replace "tmux -2" "${tmux}/bin/tmux -2" \
      --replace "tmux s" "${tmux}/bin/tmux s"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 hostmux $out/bin/hostmux
    installManPage man/hostmux.1
    installShellCompletion --zsh zsh-completion/_hostmux

    runHook postInstall
  '';

  meta = {
    description = "Small wrapper script for tmux to easily connect to a series of hosts via ssh and open a split pane for each of the hosts";
    homepage = "https://github.com/hukl/hostmux";
    license = lib.licenses.mit;
    mainProgram = "hostmux";
    maintainers = with lib.maintainers; [ fernsehmuell ];
    platforms = lib.platforms.unix;
  };
})
