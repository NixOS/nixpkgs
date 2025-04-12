{
  lib,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "hue-cli";
  gemdir = ./.;
  exes = [ "hue" ];

  passthru.updateScript = bundlerUpdateScript "hue-cli";

  meta = with lib; {
    description = "Command line interface for controlling Philips Hue system's lights and bridge";
    homepage = "https://github.com/birkirb/hue-cli";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      manveru
      nicknovitski
    ];
    mainProgram = "hue";
  };
}
