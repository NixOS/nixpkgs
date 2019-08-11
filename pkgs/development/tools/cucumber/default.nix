{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "cucumber";
  gemdir = ./.;
  exes = [ "cucumber" ];

  passthru.updateScript = bundlerUpdateScript "cucumber";

  meta = with lib; {
    description = "A tool for executable specifications";
    homepage    = https://cucumber.io/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms   = platforms.unix;
  };
}
