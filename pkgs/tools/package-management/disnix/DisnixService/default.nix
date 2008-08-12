{stdenv, fetchsvn, jdk, apacheAnt, axis2, shebangfix}:

stdenv.mkDerivation {
    name = "DisnixService-0.1";
    src = fetchsvn {
	url = https://svn.nixos.org/repos/nix/disnix/DisnixService/trunk;
	md5 = "01adbf0e50c66e03e19534151ae35ec7";
	rev = 12601;
    };
    
    buildInputs = [ jdk apacheAnt axis2 shebangfix ];
    builder = ./builder.sh;
    inherit axis2;
    
    meta = {
	license = "LGPL";
    };
}
