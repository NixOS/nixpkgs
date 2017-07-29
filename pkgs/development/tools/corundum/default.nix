{ lib, bundlerApp }:

bundlerApp {
  pname = "corundum";
  gemdir = ./.;
  exes = [ "corundum-skel" ];

  meta = with lib; {
    description = "Tool and libraries for maintaining Ruby gems.";
    homepage    = https://github.com/nyarly/corundum;
    license     = licenses.mit;
    maintainers = [ maintainers.nyarly ];
    platforms   = platforms.unix;
  };
}
