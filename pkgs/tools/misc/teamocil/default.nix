{ lib, bundlerEnv, ruby, bundlerUpdateScript }:

bundlerEnv {
  inherit ruby;
  pname = "teamocil";
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "teamocil";

  meta = with lib; {
    description     = "Simple tool used to automatically create windows and panes in tmux with YAML files";
    homepage        = "https://github.com/remiprev/teamocil";
    license         = licenses.mit;
    platforms       = platforms.all;
    maintainers     = with maintainers; [
      zachcoyle
      nicknovitski
    ];
    mainProgram = "teamocil";
  };
}
