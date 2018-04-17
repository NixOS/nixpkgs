{ lib, bundlerApp, ruby }:

bundlerApp {
  pname = "cddl";

  inherit ruby;
  gemdir = ./.;
  exes = [ "cddl" ];

  meta = with lib; {
    description = "A parser, generator, and validator for CDDL";
    homepage    = https://rubygems.org/gems/cddl;
    license     = with licenses; mit;
    maintainers = with maintainers; [ fdns ];
    platforms   = platforms.unix;
  };
}
