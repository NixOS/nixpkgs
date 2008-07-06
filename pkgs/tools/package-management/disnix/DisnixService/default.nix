{stdenv, fetchsvn, jdk, apacheAnt, axis2}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "946fe0a6a5aa1add8e71c1f1b04c6a6b";
	rev = 12289;
    };
    
    buildInputs = [ jdk apacheAnt axis2 ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}