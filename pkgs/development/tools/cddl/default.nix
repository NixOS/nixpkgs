{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "cddl";

  gemdir = ./.;
  exes = [ "cddl" ];

  passthru.updateScript = bundlerUpdateScript "cddl";

  meta = with lib; {
    description = "A parser, generator, and validator for CDDL";
    homepage    = https://rubygems.org/gems/cddl;
    license     = with licenses; mit;
    maintainers = with maintainers; [ fdns nicknovitski ];
    platforms   = platforms.unix;
  };
}
