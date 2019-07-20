{ lib, bundlerApp }:

bundlerApp {
  pname = "lolcat";
  gemdir = ./.;
  exes = [ "lolcat" ];

  meta = with lib; {
    description = "A rainbow version of cat";
    homepage    = https://github.com/busyloop/lolcat;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ StillerHarpo manveru ];
  };
}
