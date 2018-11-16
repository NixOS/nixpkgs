{ lib, bundlerApp, ruby }:

bundlerApp {
  pname = "cbor-diag";

  inherit ruby;
  gemdir = ./.;

  exes = [
    "cbor2diag.rb"
    "cbor2json.rb"
    "cbor2pretty.rb"
    "cbor2yaml.rb"
    "diag2cbor.rb"
    "diag2pretty.rb"
    "json2cbor.rb"
    "json2pretty.rb"
    "pretty2cbor.rb"
    "pretty2diag.rb"
    "yaml2cbor.rb"
  ];

  meta = with lib; {
    description = "CBOR diagnostic utilities";
    homepage    = https://github.com/cabo/cbor-diag;
    license     = with licenses; asl20;
    maintainers = with maintainers; [ fdns ];
    platforms   = platforms.unix;
  };
}
