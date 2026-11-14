{
  lib,
  mkTmuxPlugin,
  agent-usage,
  bash,
  makeWrapper,
}:

mkTmuxPlugin {
  inherit (agent-usage) version src;

  pluginName = "agent-usage";
  rtpFilePath = "plugin/tmux-agent-usage.tmux";

  patches = [ ./skip-auto-install.patch ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash ];

  postInstall = ''
    patchShebangs $target/plugin/tmux-agent-usage.tmux $target/plugin/bin/status.sh
    wrapProgram $target/plugin/bin/status.sh \
      --prefix PATH : ${lib.makeBinPath [ agent-usage ]}
  '';

  meta = {
    description = "Display AI agent rate limit usage in your tmux status bar";
    homepage = "https://github.com/raine/tmux-agent-usage";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sei40kr ];
    platforms = lib.platforms.unix;
  };
}
