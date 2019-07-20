{ lib, bundlerEnv, ruby }:

bundlerEnv rec {
  inherit ruby;
  pname = "teamocil";
  gemdir = ./.;

  meta = with lib; {
    description     = "A simple tool used to automatically create windows and panes in tmux with YAML files";
    homepage        = https://github.com/remiprev/teamocil;
    license         = licenses.mit;
    platforms       = platforms.all;
    maintainers     = with maintainers; [
      zachcoyle 
    ];
  };
}
