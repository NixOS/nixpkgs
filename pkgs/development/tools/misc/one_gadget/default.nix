{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "one_gadget";
  gemdir = ./.;
  exes = [ "one_gadget" ];

  passthru.updateScript = bundlerUpdateScript "one_gadget";

  meta = with lib; {
    description = "The best tool for finding one gadget RCE in libc.so.6";
    homepage    = https://github.com/david942j/one_gadget;
    license     = licenses.mit;
    maintainers = with maintainers; [ artemist nicknovitski ];
    platforms   = platforms.unix;
  };
}
