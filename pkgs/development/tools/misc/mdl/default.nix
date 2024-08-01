{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "mdl";
  gemdir = ./.;
  exes = [ "mdl" ];

  passthru.updateScript = bundlerUpdateScript "mdl";

  meta = with lib; {
    description = "Tool to check markdown files and flag style issues";
    homepage = "https://github.com/markdownlint/markdownlint";
    license = licenses.mit;
    maintainers = with maintainers; [ gerschtli manveru nicknovitski totoroot ];
    platforms = platforms.all;
  };
}
