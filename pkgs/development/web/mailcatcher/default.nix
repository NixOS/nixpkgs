{ lib, bundlerApp }:

bundlerApp {
  pname = "mailcatcher";
  gemdir = ./.;
  exes = [ "mailcatcher" "catchmail" ];

  meta = with lib; {
    description = "SMTP server and web interface to locally test outbound emails";
    homepage    = https://mailcatcher.me/;
    license     = licenses.mit;
    maintainers = [ maintainers.zarelit ];
    platforms   = platforms.unix;
  };
}
