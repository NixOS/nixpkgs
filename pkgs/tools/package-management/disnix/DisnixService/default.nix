{stdenv, fetchsvn, jdk, apacheAnt, axis2}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "f1a5cc28b8a0f92a084111241c35045d";
	rev = 12354;
    };
    
    buildInputs = [ jdk apacheAnt axis2 ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
