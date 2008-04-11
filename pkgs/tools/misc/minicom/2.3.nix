args : with args; 
rec {
  src = fetchurl {
    url = http://alioth.debian.org/frs/download.php/2332/minicom-2.3.tar.gz;
    sha256 = "1ysn0crdhvwyvdlbw0ms5nq06xy2pd2glwjs53p384byl3ac7jra";
  };

  buildInputs = [ncurses];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = [ "doConfigure" "doMakeInstall"];
      
  name = "minicom-" + version;
  meta = {
    description = "Serial console";
  };
}
