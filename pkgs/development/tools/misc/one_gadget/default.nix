{ lib, bundlerApp }:

bundlerApp {
  pname = "one_gadget";
  gemdir = ./.;
  exes = [ "one_gadget" ];

  meta = with lib; {
    description = "The best tool for finding one gadget RCE in libc.so.6";
    homepage    = https://github.com/david942j/one_gadget;
    license     = licenses.mit;
    maintainers = [ maintainers.artemist ];
    platforms   = platforms.unix;
  };
}
