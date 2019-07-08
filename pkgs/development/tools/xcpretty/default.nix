{ lib, bundlerApp, bundler, bundix }:

bundlerApp {
  pname = "xcpretty";
  gemdir = ./.;

  exes = [ "xcpretty" ];

  passthru = {
    updateScript = ''
      set -e
      echo
      cd ${toString ./.}
      ${bundler}/bin/bundle lock --update
      ${bundix}/bin/bundix
    '';
  };

  meta = with lib; {
    description     = "Flexible and fast xcodebuild formatter";
    homepage        = https://github.com/supermarin/xcpretty;
    license         = licenses.mit;
    maintainers     = with maintainers; [
      nicknovitski
    ];
  };
}
