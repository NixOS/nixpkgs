{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "itamae";
  gemdir = ./.;
  exes = [ "itamae" ];

  passthru.updateScript = bundlerUpdateScript "itamae";

  meta = with lib; {
    description = "Simple and lightweight configuration management tool inspired by Chef";
    homepage = "https://itamae.kitchen/";
    license = with licenses; mit;
    maintainers = with maintainers; [ refi64 ];
    platforms = platforms.unix;
  };
}
