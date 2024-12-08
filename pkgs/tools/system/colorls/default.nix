{ lib, bundlerApp, ruby, bundlerUpdateScript }:

bundlerApp {
  pname = "colorls";

  gemdir = ./.;
  exes = [ "colorls" ];

  passthru.updateScript = bundlerUpdateScript "colorls";

  meta = with lib; {
    description = "Prettified LS";
    homepage    = "https://github.com/athityakumar/colorls";
    license     = with licenses; mit;
    maintainers = with maintainers; [ lukebfox nicknovitski cbley ];
    platforms   = ruby.meta.platforms;
    mainProgram = "colorls";
  };
}
