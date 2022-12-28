{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "vimgolf";
  gemdir = ./.;
  exes = [ "vimgolf" ];

  passthru.updateScript = bundlerUpdateScript "vimgolf";

  meta = with lib; {
    description = "A game that tests Vim efficiency";
    homepage = "https://vimgolf.com";
    license = licenses.mit;
    maintainers = with maintainers; [ leungbk ];
    platforms = platforms.unix;
  };
}
