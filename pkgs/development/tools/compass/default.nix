{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "compass";
  gemdir = ./.;
  exes = [ "compass" ];

  passthru.updateScript = bundlerUpdateScript "compass";

  meta = with lib; {
    description = "Stylesheet Authoring Environment that makes your website design simpler to implement and easier to maintain";
    homepage    = https://github.com/Compass/compass;
    license     = with licenses; mit;
    maintainers = with maintainers; [ offline manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
