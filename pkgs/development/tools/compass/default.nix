{ lib, bundlerEnv, bundlerUpdateScript, ruby }:

bundlerEnv {
  pname = "compass";
  version = "1.0.3";

  inherit ruby;
  gemdir = ./.;

  passthru.updateScript = bundlerUpdateScript "compass";

  meta = with lib; {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage    = "https://github.com/Compass/compass";
    license     = with licenses; mit;
    maintainers = with maintainers; [ offline manveru nicknovitski ];
    mainProgram = "compass";
    platforms   = platforms.unix;
  };
}
