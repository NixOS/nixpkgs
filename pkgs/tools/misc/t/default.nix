{ lib, bundlerApp }:

bundlerApp {
  pname = "t";
  gemdir = ./.;
  exes = [ "t" ];

  meta = with lib; {
    description = "A command-line power tool for Twitter";
    homepage    = http://sferik.github.io/t/;
    license     = licenses.asl20;
    maintainers = with maintainers; [ offline manveru ];
    platforms   = platforms.unix;
  };
}
