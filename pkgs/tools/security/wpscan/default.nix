{ bundlerApp, lib }:

bundlerApp {
  pname = "wpscan";
  gemdir = ./.;
  exes = [ "wpscan" ];

  meta = with lib; {
    description = "Black box WordPress vulnerability scanner";
    homepage    = https://wpscan.org/;
    license     = licenses.unfreeRedistributable;
    maintainers = [ maintainers.nyanloutre ];
    platforms   = platforms.unix;
};
}
