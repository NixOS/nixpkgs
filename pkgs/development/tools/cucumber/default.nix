{ lib, bundlerApp }:

bundlerApp {
  pname = "cucumber";
  gemdir = ./.;
  exes = [ "cucumber" ];

  meta = with lib; {
    description = "A tool for executable specifications";
    homepage    = https://cucumber.io/;
    license     = with licenses; mit;
    maintainers = with maintainers; [ manveru ];
    platforms   = platforms.unix;
  };
}
