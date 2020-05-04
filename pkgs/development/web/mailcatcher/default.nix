{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "mailcatcher";
  gemdir = ./.;
  exes = [ "mailcatcher" "catchmail" ];

  passthru.updateScript = bundlerUpdateScript "mailcatcher";

  meta = with lib; {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage    = "https://mailcatcher.me/";
    license     = licenses.mit;
    maintainers = with maintainers; [ zarelit nicknovitski ];
    platforms   = platforms.unix;
  };
}
