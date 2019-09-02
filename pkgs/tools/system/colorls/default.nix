{ lib, bundlerApp, ruby, bundlerUpdateScript }:

bundlerApp rec {
  pname = "colorls";

  gemdir = ./.;
  exes = [ "colorls" ];

  passthru.updateScript = bundlerUpdateScript "colorls";

  meta = with lib; {
    description = "Prettified LS";
    homepage    = https://github.com/athityakumar/colorls;
    license     = with licenses; mit;
    maintainers = with maintainers; [ lukebfox nicknovitski ];
    platforms   = ruby.meta.platforms;
  };
}
