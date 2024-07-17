{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  tmux,
}:

stdenv.mkDerivation {
  pname = "tmux-cssh";
  version = "unstable-2015-10-15";

  src = fetchFromGitHub {
    owner = "dennishafemann";
    repo = "tmux-cssh";
    rev = "21750733c5b6fa2fe23b9e50ce69d8564f2f742a";
    sha256 = "473e27f3b69864b905d1340d97917cd202705c761611eb3aec4c24521f69b52c";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp tmux-cssh $out/bin/tmux-cssh
    wrapProgram $out/bin/tmux-cssh --suffix PATH : ${tmux}/bin
  '';

  meta = {
    homepage = "https://github.com/dennishafemann/tmux-cssh";
    description = "SSH to multiple hosts at the same time using tmux";

    longDescription = ''
      tmux is a terminal multiplexer, like e.g. screen, which gives you a
      possibility to use multiple virtual terminal session within one real
      terminal session. tmux-cssh (tmux-cluster-ssh) sets a comfortable and
      easy to use functionality, clustering and synchronizing virtual
      tmux-sessions, on top of tmux. No need for a x-server or x-forwarding.
      tmux-cssh works just with tmux and in an low-level terminal-environment,
      like most server do.
    '';

    license = lib.licenses.asl20;

    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ zimbatm ];
    mainProgram = "tmux-cssh";
  };
}
