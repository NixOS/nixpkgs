{ lib, bundlerEnv, ruby, libpcap}:

bundlerEnv rec {
  name = "bettercap-${version}";

  version = (import gemset).bettercap.version;
  inherit ruby;
  gemdir = ./.;
  gemset = ./gemset.nix;

  buildInputs = [ libpcap ruby ];

  meta = with lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic in realtime, sniff for credentials and much more.
    '' ;
    homepage = https://www.bettercap.org/;
    license = with licenses; gpl3;
    maintainers = with maintainers; [ y0no ];
    platforms = platforms.all;
  };
}
