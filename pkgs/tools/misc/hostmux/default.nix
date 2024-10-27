{ lib
, stdenv
, fetchFromGitHub
, installShellFiles
, openssh
, tmux
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hostmux";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "hukl";
    repo = "hostmux";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-Rh8eyKoUydixj+X7muWleZW9u8djCQAyexIfRWIOr0o=";
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
      --replace-fail "SSH_CMD=ssh" "SSH_CMD=${openssh}/bin/ssh" \
      --replace-fail "TMUX_CMD=tmux" "TMUX_CMD=${tmux}/bin/tmux"
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
    changelog = "https://github.com/hukl/hostmux/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hostmux";
    maintainers = with lib.maintainers; [ fernsehmuell ];
    platforms = lib.platforms.unix;
  };
})
