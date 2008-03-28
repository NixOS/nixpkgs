
args : with args; 
rec {
  src = fetchurl {
    url = http://ftp.gnu.org/gnu/ddrescue/ddrescue-1.8.tar.bz2;
    sha256 = "080k1s4knh9baw3dxr5vqjjph6dqzkfpk0kpld0a3qc07vsxmhbz";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "ddrescue-" + version;
  meta = {
    description = "GNU ddrescue - advanced dd for corrupted media";
  };
}
  
