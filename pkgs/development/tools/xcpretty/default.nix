{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "xcpretty";
  gemdir = ./.;

  exes = [ "xcpretty" ];

  passthru = {
    updateScript = bundlerUpdateScript "xcpretty";
  };

  meta = with lib; {
    description     = "Flexible and fast xcodebuild formatter";
    homepage        = "https://github.com/supermarin/xcpretty";
    license         = licenses.mit;
    maintainers     = with maintainers; [
      nicknovitski
    ];
  };
}
